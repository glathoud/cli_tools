# `cli_tools` 

Command-line tools.

### backup_tar_create.sh/backup_tar_expand.sh 

...compact/expand each file & dir in the current directory, to:
 * saves space, 
 * reduces the number of files, 
 * and permits to use backup tools that are not fully compatible with Unix links.

### col2page.sh

[Required: bash & ocaml]

Generate multi-column pages of text, as dense as possible.
 * Input: single column of text (from the standard input)
 * Output: multi-column text (to the standard output), where columns are grouped to form pages.

Optional arguments: [lipp [copp]]

    lipp: number of lines per page
           (default: should be 105, see ./src/col2page.ml)

    copp: number of columns per page 
           (default: should be 119 * lipp / 105, see ./src/col2page.ml)

Example to quickly test it:
```
reset ; for i in {1..10000} ; do echo $i ; done | col2page.sh
```
...which outputs:
```
1  |106|211|316|421|526|631|736|841|946 |1051|1156|1261|1366|1471|1576|1681|1786|1891|1996|2101|2206|2311|2416|2521
2  |107|212|317|422|527|632|737|842|947 |1052|1157|1262|1367|1472|1577|1682|1787|1892|1997|2102|2207|2312|2417|2522
3  |108|213|318|423|528|633|738|843|948 |1053|1158|1263|1368|1473|1578|1683|1788|1893|1998|2103|2208|2313|2418|2523
4  |109|214|319|424|529|634|739|844|949 |1054|1159|1264|1369|1474|1579|1684|1789|1894|1999|2104|2209|2314|2419|2524
5  |110|215|320|425|530|635|740|845|950 |1055|1160|1265|1370|1475|1580|1685|1790|1895|2000|2105|2210|2315|2420|2525
6  |111|216|321|426|531|636|741|846|951 |1056|1161|1266|1371|1476|1581|1686|1791|1896|2001|2106|2211|2316|2421|2526
7  |112|217|322|427|532|637|742|847|952 |1057|1162|1267|1372|1477|1582|1687|1792|1897|2002|2107|2212|2317|2422|2527
8  |113|218|323|428|533|638|743|848|953 |1058|1163|1268|1373|1478|1583|1688|1793|1898|2003|2108|2213|2318|2423|2528
9  |114|219|324|429|534|639|744|849|954 |1059|1164|1269|1374|1479|1584|1689|1794|1899|2004|2109|2214|2319|2424|2529
10 |115|220|325|430|535|640|745|850|955 |1060|1165|1270|1375|1480|1585|1690|1795|1900|2005|2110|2215|2320|2425|2530
11 |116|221|326|431|536|641|746|851|956 |1061|1166|1271|1376|1481|1586|1691|1796|1901|2006|2111|2216|2321|2426|2531
12 |117|222|327|432|537|642|747|852|957 |1062|1167|1272|1377|1482|1587|1692|1797|1902|2007|2112|2217|2322|2427|2532
...
```

More documentation in the file itself: [col2page.sh](col2page.sh)

### col2page_ps.sh

[Required: bash & ocaml]

Wrapper around col2page.sh, that feeds a2ps and writes a file.
 * Input: single column of text (from the standard input)
 * Output: multi-column **PS file** where columns are grouped to form pages.

Mandatory parameter: output filename.

Example to quickly test it:
```
for i in {1..10000} ; do echo $i ; done | col2page_ps.sh test.ps
evince test.ps
```

More documentation in the file itself: [col2page_ps.sh](col2page_ps.sh)
