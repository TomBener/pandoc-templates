#!/bin/zsh

# Find and replace texts in `ref.bib`
sed -i '' -e 's/@misc{/@online{/g' \
-e 's|'"howpublished = {"'|'"url = {"'|g' \
-e 's|'"note = {"'|'"urldate = {"'|g' ref.bib

# Generate `main.docx` via pandoc
pandoc -C -L lua-filters/rsbc.lua \
--reference-doc docx/minion-reference.docx \
input.md -o docx/main.docx

# Generate `main.html` via pandoc
pandoc -s --self-contained -C \
-L lua-filters/rsbc.lua --toc \
-c https://cdn.jsdelivr.net/npm/water.css@2/out/water.min.css \
input.md -o html/main.html

# Generate `input.tex` via pandoc
cd pdf
pandoc --natbib ../input.md -o input.tex

# Replace citealp with citeyear in `input.tex`
sed -i '' -e 's/citealp/citeyear/g' input.tex

# Generate `main.pdf` via latexmk
latexmk -quiet \
-xelatex main.tex \
-outdir=auxiliary

# Move `main.pdf` to main folder
cd auxiliary
mv main.pdf ../

# Remove auxiliary folder
cd ..
rm -r auxiliary
