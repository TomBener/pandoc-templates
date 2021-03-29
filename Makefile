# CSL stylesheet
CSL = --csl stylesheets/gbt7714-author-date.csl

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

# Perl with options
PERL = perl -CSD -Mutf8 -i -pe

# Latexmk
LMK = /usr/local/bin/latexmk

.SILENT:
docx: input.md
	pandoc $(PCR) -C -N $(CSL) $(REFDOCX) $< $(EXTENSIONS) -t docx -o main.$@
	# Unzip `main.docx` as the directory `unzipped`
	unzip -q main.docx -d unzipped
	# Replace `等` with `et al.` for unzipped `main.docx`
	$(PERL) 's/([a-zA-Z])(,\s|\s)(等)/\1\2et al./g' $(PATH)/document.xml
	$(PERL) 's/([z-zA-Z]\s)(等)/\1et al./g' $(PATH)/footnotes.xml

	# Replace `版` with `ed` for the English bibliography in `main.docx`
	$(PERL) \
	's/(\w*|\w\p{P}*)(<\/w:t><\/w:r><w:r><w:t xml:space="preserve">)(\[M\].\s\d\s)版./\1\2\3ed./g' \
	$(PATH)/document.xml

	# Remove the space before inline citation at the beginning of a sentence in `main.docx`
	$(PERL) \
	's/([，。；！？”])(<\/w:t><\/w:r><w:r><w:t xml:space="preserve">)\s/\1/g' \
	$(PATH)/document.xml

	# Tweaks for quotation marks wrapped in Chinese texts
	# Double quotation marks wrapped in Chinese texts
	$(PERL) 's/(<\/w:t>)(<\/w:r><w:r>)(<w:t xml:space="preserve">“<\/w:t><\/w:r><w:r><w:t xml:space="preserve">[\w\p{P}\s]*\p{Han}+[\w\p{P}\s]*)(<\/w:t>)(<\/w:r><w:r>)(<w:t xml:space="preserve">”)/\1<w:rPr><w:rFonts w:hint="eastAsia"\/><w:lang w:eastAsia="zh-CN"\/><\/w:rPr>\3\4<w:rPr><w:rFonts w:hint="eastAsia"\/><w:lang w:eastAsia="zh-CN"\/><\/w:rPr>\6/g' $(PATH)/document.xml
	
	# Double or single quotation marks and wrapped Chinese texts
	$(PERL) 's/(<\/w:r><w:r>)(<w:t xml:space="preserve">)([\w\p{P}\s]*[“‘]\p{Han}+[”’][\w\p{P}\s]*)/<w:rPr><w:rFonts w:hint="eastAsia"\/><w:lang w:eastAsia="zh-CN"\/><\/w:rPr>\2\3/g' $(PATH)/document.xml

	# zip `main.docx`
	cd unzipped; $(ZIP) -r -q ../main.docx *

	# Remove the unzipped directories
	rm -r unzipped

.PHONY: clean

clean:
	rm *html *.docx *.tex
