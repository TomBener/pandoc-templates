# Pandoc Templates

Pandoc templates to convert Markdown files to DOCX, PDF or HTML for academic writing.

## Generate outputs

```sh
$ ./make.sh
```

## Extra issues to be fixed

### [ref.bib](ref.bib)

> ⚠️ Please note there is no need to edit `ref.bib` manually as it can be handled by `make.sh` automatically.

Nagivate to `Preferences -> Better BibTeX -> Advanced -> postscript` in Zotero, and paste the modified JavaScript [code block](https://retorque.re/zotero-better-bibtex/exporting/scripting/#add-accessdate-url-for-bibtex) below:

```javascript
if (Translator.BetterBibTeX && item.itemType === 'webpage') {
    if (item.url) {
      reference.add({ name: 'howpublished', bibtex: "{" + reference.enc_verbatim({value: item.url}) + "}" });
    }
    if (item.accessDate) {
      reference.add({ name: 'note', value: item.accessDate.replace(/\s*T?\d+:\d+:\d+.*/, '') });
    }
  }
```

And then:

- Replace `@misc{` with `@online{`
- Replace `howpublished = {` with `url = {`
- Replace `note = {` with `urldate = {`

Which can be achieved by running the shell script below in command line:

```sh
sed -i '' -e 's/@misc{/@online{/g' -e 's|'"howpublished = {"'|'"url = {"'|g' -e 's|'"note = {"'|'"urldate = {"'|g' ref.bib
```

### [main.docx](main.docx)

- Replace `et al.` with `等` for Chinese authors (with wildcard character)
  1. Find `[!^1-^127] et al.` and `[!^1-^127], et al.`, and replace both with `^& ƒ`
  2. Find `et al. ƒ`, and replace with `等`
- Replace `， ` with `，`, `。 ` with `。` etc. for removing space before multiple 'AuthorInText' citations 
- Sort Chinese bibliography alphabetically according to the pinyin of authors.
