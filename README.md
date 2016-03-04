# `cli_tools` 

Command-line tools.

### backup_tar_create.sh/backup_tar_expand.sh 

...compact/expand each file & dir in the current directory, to:
 * saves space, 
 * reduces the number of files, 
 * and permits to use backup tools that are not fully compatible with Unix links.

### col2page.sh

[Required: bash & ocaml]

Save the forest: take a single column of text as input, and generate
a multi-column text output, where columns are grouped to form pages.

Optional arguments: [lipp [copp]]

    lipp: number of lines per page
           (default: should be 105, see ./src/col2page.ml)

     copp: number of columns per page 
           (default: should be 119 * lipp / 105, see ./src/col2page.ml)

Example to quickly test it:
```
reset ; for i in {1..10000} ; do echo $i ; done | col2page.sh
```

More documentation in the file itself: [col2page.sh](col2page.sh)

### col2page_ps.sh

[Required: bash & ocaml]

Save the forest: take a single column of text as input, and generate
a multi-column *PS* output, where columns are grouped to form pages.

This is a wrapper around col2page.sh, that feeds a2ps and writes a file.

Example to quickly test it:
```
for i in {1..10000} ; do echo $i ; done | col2page_ps.sh test.ps
evince test.ps
```

More documentation in the file itself: [col2page_ps.sh](col2page_ps.sh)
