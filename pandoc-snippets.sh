pandoc -o input.html input.txt

pandoc -s -o input.html input.txt  # `s` means `standalone`

pandoc -f markdown -t latex hello.txt  # convert hello.txt from Markdown to LaTeX, `--from` is available as well

pandoc -f html -t markdown hello.txt  # convert hello.html from HTML to Markdown

pandoc test.txt -o test.pdf  # use LaTeX to create the PDF

pandoc -f html -t markdown https://www.fsf.org  # reading from the Web

pandoc -f html -t markdown --request-header User-Agent:"Mozilla/5.0" \
  https://www.fsf.org  # a custom User-Agent

pandoc --wrap=none -o output.md input.docx  # remove unnecessary line-break

pandoc --wrap=none -t commonmark input.docx -o output.md  # no escape in markdown *****

pandoc --reference-doc twocolumns.docx -o UsersGuide.docx MANUAL.txt  # docx with a reference docx

pandoc -s --bibliography biblio.json --citeproc --csl chicago-fullnote-bibliography.csl CITATIONS -o example24b.html  # citations

pandoc -s math.tex -o example30.docx  # LaTeX to docx

pandoc MANUAL.txt --pdf-engine=xelatex -o example13.pdf  # markdown to pdf
