pandoc -o input.html input.txt

pandoc -s -o input.html input.txt  # `s` means `standalone`

pandoc -f markdown -t latex hello.txt  # convert hello.txt from Markdown to LaTeX, `--from` is available as well

pandoc -f html -t markdown hello.txt  # convert hello.html from HTML to Markdown

pandoc test.txt -o test.pdf  # use LaTeX to create the PDF

pandoc -f html -t markdown https://www.fsf.org  # reading from the Web

pandoc -f html -t markdown --request-header User-Agent:"Mozilla/5.0" \
  https://www.fsf.org  # a custom User-Agent

pandoc --wrap=none -o output.md input.docx  # remove unnecessary line-break
