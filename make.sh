#!/bin/zsh

## The shell (I personally use zsh, more specifically, it's Oh My Zsh at https://ohmyz.sh) 
## script for generating the HTML, DOCX and PDF from Markdown via Pandoc for Chinese users.
## Tested on macOS Big Sur, it can be used on Linux with a few tweaks. While on Windows, 
## it is recommended to use WSL, which is available at https://docs.microsoft.com/windows/wsl/
## Author: TomBener
## Email: retompi@gmail.com

############################################################################## HTML
# Generate `main.html` via pandoc
pandoc -s --self-contained -F pandoc-crossref \
--csl stylesheets/gb-t-7714-2015-author-date.csl \
-C -L lua-filters/rsbc.lua --toc \
-c https://cdn.jsdelivr.net/npm/water.css@2/out/water.min.css \
input.md -o main.html

########################################################################################### DOCX
# Generate `main.docx` via pandoc
pandoc -F pandoc-crossref -C -N \
--csl stylesheets/gb-t-7714-2015-author-date.csl \
--reference-doc stylesheets/ref.docx \
-M date="`date -u '+%Y年%m月%d日'`" \
input.md -f markdown+autolink_bare_uris \
-t docx -o main.docx

# Unzip `main.docx` as the directory `unzipped`
unzip -q main.docx -d unzipped

# Go to the directory `unzipped`
cd unzipped

# Replace `et al.` with `等` for unzipped `main.docx`
perl -CSD -Mutf8 -i -pe 's/(\p{Han})(,\s|\s)(et al.)/\1\2等/g' word/document.xml
perl -CSD -Mutf8 -i -pe 's/(\p{Han}\s)(et al.)/\1等/g' word/footnotes.xml

# Replace `版` with `ed` for the English bibliography in `main.docx`
perl -CSD -Mutf8 -i -pe \
's/(\w*|\w\p{P}*)(<\/w:t><\/w:r><w:r><w:t xml:space="preserve">)(\[M\].\s\d\s)版./\1\2\3ed./g' \
word/document.xml

# Remove the space before inline citation at the beginning of a sentence in `main.docx`
perl -CSD -Mutf8 -i -pe \
's/([，。；！？”])(<\/w:t><\/w:r><w:r><w:t xml:space="preserve">)\s/\1/g' \
word/document.xml

# Tweaks for quotation marks wrapped in Chinese texts
# Double quotation marks wrapped in Chinese texts
perl -CSD -Mutf8 -i -pe 's/(<\/w:t>)(<\/w:r><w:r>)(<w:t xml:space="preserve">“<\/w:t><\/w:r><w:r><w:t xml:space="preserve">[\w\p{P}\s]*\p{Han}+[\w\p{P}\s]*)(<\/w:t>)(<\/w:r><w:r>)(<w:t xml:space="preserve">”)/\1<w:rPr><w:rFonts w:hint="eastAsia"\/><w:lang w:eastAsia="zh-CN"\/><\/w:rPr>\3\4<w:rPr><w:rFonts w:hint="eastAsia"\/><w:lang w:eastAsia="zh-CN"\/><\/w:rPr>\6/g' word/document.xml

# Double or single quotation marks and wrapped Chinese texts
perl -CSD -Mutf8 -i -pe 's/(<\/w:r><w:r>)(<w:t xml:space="preserve">)([\w\p{P}\s]*[“‘]\p{Han}+[”’][\w\p{P}\s]*)/<w:rPr><w:rFonts w:hint="eastAsia"\/><w:lang w:eastAsia="zh-CN"\/><\/w:rPr>\2\3/g' word/document.xml

# zip `main.docx`
zip -r -q ../main.docx *

# Go back to the main directory
cd -

# Remove the unzipped directories
rm -r unzipped

# Next Need to edit `main.docx` manually
# 1. Sort the bibliography based on the pinyin of authors
# 2. Set all Chinese texts wrapped as zh-CN 
# or find `“[、-﨩]*”`, then set the language to zh-CN

################################################################################################# PDF
# Non-Chinese texts wrapped in quotation marks in `ref.bib`
# Double
perl -CSD -Mutf8 -i -pe 's/([“"])([a-zA-Z0-9\{])/``\2/g; \
s/([a-zA-Z0-9\}])(["”])/\1'\'\''/g' ref.bib
# Single
perl -CSD -Mutf8 -i -pe 's/([‘'\''])([a-zA-Z0-9\{])/`\2/g; \
s/([a-zA-Z0-9\}])(’)/\1'\''/g' ref.bib

# The possessive form
sed -i '' -E 's/([a-zA-Z\}])([`‘’])s/\1'\''s/g' ref.bib

# Find and replace texts in `ref.bib` (for Better BibTeX exported from Zotero)
#sed -i '' -e 's/@misc{/@online{/g; s|'"howpublished = {"'|'"url = {"'|g; s|'"note = {"'|'"urldate = {"'|g' ref.bib

# Go into the stylesheets directory
cd stylesheets

# Generate `input.tex` via pandoc
pandoc -F pandoc-crossref --biblatex \
--wrap=none ../input.md \
-f markdown+smart+autolink_bare_uris \
-t latex -o input.tex

# Phrases with Chinese characters wrapped in quotation marks in `input.tex`
perl -CSD -Mutf8 -i -pe 's/(``)([\w\p{P}\s]*\p{Han}+[\w\p{P}\s]*)('\'\'')/“\2”/g; \
s/(`)([\w\p{P}\s]*\p{Han}+[\w\p{P}\s]*)('\'')/‘\2’/g' input.tex

# Generate `main.pdf` via latexmk
latexmk -xelatex main.tex -quiet

# Move generated pdf file to the main directory
mv main.pdf ../

# Remove auxiliary files
latexmk -c
rm *.bbl *.xml *.xdv input.tex
