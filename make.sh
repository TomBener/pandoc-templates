#!/bin/zsh

## The shell (I personally use zsh, more specifically, it's Oh My Zsh at https://ohmyz.sh) 
## script for generating the HTML, DOCX and PDF from Markdown via Pandoc for Chinese users.
## Tested on macOS Big Sur, it can be used on Linux with a few tweaks. While on Windows, 
## it is recommended to use WSL, which is available at https://docs.microsoft.com/windows/wsl/
## Author: TomBener
## Email: retompi@gmail.com

############################################################################## HTML
# Generate `main.html` via pandoc
pandoc --self-contained -F pandoc-crossref \
--csl stylesheets/gbt7714-author-date.csl \
-C -L lua-filters/rsbc.lua --toc \
-c https://cdn.jsdelivr.net/npm/water.css@2/out/water.min.css \
input.md -f markdown+autolink_bare_uris -t html -o main.html

########################################################################################### DOCX
# Generate `main.docx` via pandoc
pandoc -F pandoc-crossref -C -N \
--csl stylesheets/gbt7714-author-date.csl \
--reference-doc stylesheets/ref.docx \
-M date="`date -u '+%Y年%m月%d日'`" \
input.md -f markdown+autolink_bare_uris \
-t docx -o main.docx

# Unzip `main.docx` as the directory `unzipped`
unzip -q main.docx -d unzipped

# Go to the directory `unzipped`
cd unzipped

# Replace `等` with `et al.` for unzipped `main.docx`
perl -CSD -Mutf8 -i -pe 's/([a-zA-Z])(,\s|\s)(等)/\1\2et al./g' word/document.xml
perl -CSD -Mutf8 -i -pe 's/([z-zA-Z]\s)(等)/\1et al./g' word/footnotes.xml

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

# Next need to sort the bibliography based on the pinyin of authors manually.

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
