#!/bin/zsh

# Find and replace texts in `ref.bib`
sed -i '' -e 's/@misc{/@online{/g' \
-e 's|'"howpublished = {"'|'"url = {"'|g' \
-e 's|'"note = {"'|'"urldate = {"'|g' ref.bib

# Generate `main.docx` via pandoc
pandoc -F pandoc-crossref -C \
-L lua-filters/rsbc.lua \
--reference-doc docx/ref.docx \
input.md -f markdown+autolink_bare_uris \
-t docx -o docx/main.docx

# Generate `main.html` via pandoc
pandoc -s --self-contained -F pandoc-crossref \
-C -L lua-filters/rsbc.lua --toc \
-c https://cdn.jsdelivr.net/npm/water.css@2/out/water.min.css \
input.md -o html/main.html

# Generate `input.tex` via pandoc
cd pdf
pandoc -F pandoc-crossref --natbib ../input.md \
-f markdown+smart+autolink_bare_uris \
-t tex -o input.tex

# Replace citealp with citeyear in `input.tex`
sed -i '' -e 's/citealp/citeyear/g' input.tex

# Generate `main.pdf` via latexmk
latexmk -quiet \
-xelatex main.tex \
-outdir=auxiliary

# Move `main.pdf` to main folder
cd auxiliary
mv main.pdf ../

# Remove the auxiliary folder
cd ..
rm -r auxiliary
