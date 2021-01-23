SRC = $(wildcard *.md)

# CSL stylesheet
CSL = --csl stylesheets/gb-t-7714-2015-author-date.csl

# CSS stylesheet
# CSS = -c stylesheets/github.css
CSS = -c https://cdn.jsdelivr.net/npm/water.css@2/out/water.min.css

# DOCX template
REFDOCX = --reference-doc stylesheets/ref.docx

# Lua filters for renoving space
RSBC = -L lua-filters/rsbc.lua

# Pandoc Markdown options
EXTENSIONS = -f markdown+autolink_bare_uris

# Pandoc Crossref
PCR = -F /usr/local/bin/pandoc-crossref

# zip command
ZIP = /usr/bin/zip

# Directory path to unzipped docx
PATH = unzipped/word

## x.pdf depends on x.md, x.html depends on x.md, etc
HTML = $(SRC:.md=.html)
DOCX = $(SRC:.md=.docx)
TEX = $(SRC:.md=.tex)
PDF = $(SRC:.md=.pdf)

all:	
	$(MD) $(HTML) $(DOCX) $(TEX) $(PDFS)

pdf:
	clean $(PDFS)
html:
	clean $(HTML)
tex:
	clean $(TEX)
docx:
	clean $(DOCX)

.SILENT:
main.docx: input.md
	pandoc $(PCR) -C -N $(CSL) $(REFDOCX) $< $(EXTENSIONS) -t docx -o $@
	# Unzip `main.docx` as the directory `unzipped`
	unzip -q main.docx -d unzipped
	# Replace `et al.` with `等` for unzipped `main.docx`
	perl -CSD -Mutf8 -i -pe 's/(\p{Han})(,\s|\s)(et al.)/\1\2等/g' $(PATH)/document.xml
	perl -CSD -Mutf8 -i -pe 's/(\p{Han}\s)(et al.)/\1等/g' $(PATH)/footnotes.xml

	# Replace `版` with `ed` for the English bibliography in `main.docx`
	perl -CSD -Mutf8 -i -pe \
	's/(\w*|\w\p{P}*)(<\/w:t><\/w:r><w:r><w:t xml:space="preserve">)(\[M\].\s\d\s)版./\1\2\3ed./g' \
	$(PATH)/document.xml

	# Remove the space before inline citation at the beginning of a sentence in `main.docx`
	perl -CSD -Mutf8 -i -pe \
	's/([，。；！？”])(<\/w:t><\/w:r><w:r><w:t xml:space="preserve">)\s/\1/g' \
	$(PATH)/document.xml

	# zip `main.docx`
	cd unzipped; $(ZIP) -r -q ../main.docx *

.PHONY: all clean

clean:
	rm -f *.html *.pdf *.tex *.aux *.log
