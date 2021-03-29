# Pandoc Templates

Pandoc templates to convert Markdown files to DOCX, PDF or HTML for academic writing, especially for Chinese writing.

> 🔗 [Markdown 写作，Pandoc 转换：我的纯文本学术写作流程 - 少数派](https://sspai.com/post/64842)

## Environment

The Unix-like operating system (macOS, Linux etc.) should work well with the scripts. For Windows users, it might need to use [WSL](https://docs.microsoft.com/windows/wsl) or [PowerShell](https://docs.microsoft.com/powershell) (I’m not sure).

## Usage

```sh
# Make the script executable
$ chmod +x make.sh

# Run the script
$ ./make.sh
```

## TODO

- [ ] Sort the Chinese bibliography based on the pinyin of authors with scripts. Currently this only can be done manually (be carefule of the polyphone character).
- [ ] Tweaks for the format of table and figure in `ref.docx`.

## Thanks

- [Pandoc](https://github.com/jgm/pandoc)
- [pandoc-crossref](https://github.com/lierdakil/pandoc-crossref)
- [Pandoc Citer](https://github.com/notZaki/PandocCiter)
- [Perl](https://www.perl.org)
- [Markdown](https://daringfireball.net/projects/markdown)
- [LaTeX](https://github.com/latex3)
- [biblatex-gb7714-2015](https://github.com/hushidong/biblatex-gb7714-2015)
- [Zotero](https://www.zotero.org)
- [Better BibTeX for Zotero](https://github.com/retorquere/zotero-better-bibtex)

## License

[MIT License](LICENSE)
