# Pandoc Templates

Pandoc templates to convert Markdown files to DOCX, PDF or HTML for academic writing.

## Generate outputs

```sh
# Make the script executable
$ chmod +x make.sh

# Run the script
$ ./make.sh

# or by this command to execute:
# sh make.sh
```

## Extra issues to be fixed with generated `main.docx`

1. Sort the Chinese bibliography based on the pinyin of authors (be carefule of the polyphone character).
2. Set all Chinese texts as `zh-CN`, or find `“[、-﨩]*”` (turn on the wildcard mode) then change the selected texts to `zh-CN`.
