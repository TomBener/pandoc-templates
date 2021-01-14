# Pandoc Templates

Pandoc templates to convert Markdown files to DOCX, PDF or HTML for academic writing.

## Generate outputs

```sh
$ ./make.sh
```

Or

```sh
$ sh make.sh
```

## Extra issues to be fixed with generated `main.docx`

### Issues on `et al.` and `等`

1. `lang="en-US"` in the `.csl` file

Replace `([、-﨩])(? )(et al.)` with `\1\2等` for Chinese authors (with wildcard character)

2. `lang="zh-CN"` in the `.csl` file

Replace `([a-zA-Z])(? )(等)` with `\1\2et al.` for Non-Chinese authors (with wildcard character)

### Others

- Replace `， ` with `，`, `。 ` with `。` etc. for removing space before multiple 'AuthorInText' citations 
- Sort Chinese bibliography alphabetically according to the pinyin of authors (Be carefule of the polyphone character)
- Remove the number before `参考文献`
- Change the language of Chinese texts for correcting the quotation mark
