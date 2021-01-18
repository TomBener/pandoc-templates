#!/bin/bash

############################################################################## HTML
# Generate `main.html` via pandoc
pandoc -s --self-contained -F pandoc-crossref \
--csl gb-t-7714-2015-author-date.csl \
-C -L lua-filters/rsbc.lua --toc \
-c https://cdn.jsdelivr.net/npm/water.css@2/out/water.min.css \
input.md -o html/main.html

########################################################################################### DOCX
# Generate `main.docx` via pandoc
pandoc -F pandoc-crossref -C -N \
--csl gb-t-7714-2015-author-date.csl \
--reference-doc docx/ref.docx \
-M date="`date -u '+%Y年%m月%d日'`" \
input.md -f markdown+autolink_bare_uris \
-t docx -o docx/main.docx

# Unzip `main.docx` as the directory `unzipped`
unzip -q docx/main.docx -d docx/unzipped

# Go to the directory `unzipped`
cd docx/unzipped

# Replace `et al.` with `等` for `main.docx`
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

# zip `main.docx`
zip -r -q ../main.docx *

# Go back to the main directory
cd -

# Remove the unzipped directories
rm -r docx/unzipped

# Next Need to edit `main.docx` manually
# 1. Sort the bibliography based on the pinyin of the author
# 2. Set all Chinese texts wrapped as zh-CN 
# or find `“[、-﨩]*”`, then change the language to zh-CN

################################################################################################# PDF
# Generate `input.tex` via pandoc
cd pdf
pandoc -F pandoc-crossref --biblatex ../input.md \
-f markdown+smart+autolink_bare_uris \
-t latex -o input.tex

# Phrases with Chinese characters wrapped in quotation marks in `input.tex`
perl -CSD -Mutf8 -i -pe 's/(``)([\w\p{P}\s]*\p{Han}+[\w\p{P}\s]*)('\'\'')/“\2”/g; \
s/(`)([\w\p{P}\s]*\p{Han}+[\w\p{P}\s]*)('\'')/‘\2’/g' input.tex

# Non-Chinese texts wrapped in quotation marks in `ref.bib`
# Double
perl -CSD -Mutf8 -i -pe 's/([“"])([a-zA-Z0-9\{])/``\2/g; \
s/([a-zA-Z0-9\}])(["”])/\1'\'\''/g' ../ref.bib
# Single
perl -CSD -Mutf8 -i -pe 's/([‘'\''])([a-zA-Z0-9\{])/`\2/g; \
s/([a-zA-Z0-9\}])(’)/\1'\''/g' ../ref.bib

# The possessive form
sed -i '' -E 's/([a-zA-Z\}])([`‘’])s/\1'\''s/g' ../ref.bib

# Generate `main.pdf` via latexmk
latexmk -xelatex main.tex -quiet

# Remove auxiliary files
latexmk -c
rm *.bbl *.xml *.xdv
