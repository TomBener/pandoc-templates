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

### `lang="en-US"` in `.csl`

Replace `et al.` with `等` for Chinese authors (with wildcard character)

1. Find `[!^1-^127] et al.` and `[!^1-^127], et al.`, and replace both with `^& ƒ`
2. Find `et al. ƒ`, and replace with `等`

### `lang="zh-CN"` in `.csl`

Replace `等` with `et al.` for Non-Chinese authors (with wildcard character)

1. Find `[a-zA-Z] 等` and `[a-zA-Z], 等`, and replace both with `^& ƒ`
2. Find `et al. ƒ`, and replace with `等`

### Others

- Replace `， ` with `，`, `。 ` with `。` etc. for removing space before multiple 'AuthorInText' citations 
- Sort Chinese bibliography alphabetically according to the pinyin of authors (Be carefule of the polyphone character)
- Remove the number before `参考文献`
- Change the language of Chinese texts for correcting the quotation mark
