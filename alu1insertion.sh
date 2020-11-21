
#!/bin/bash

find *.fastq.gz -type f | parallel -j+1 zgrep -c -e ACCGCGCCCGGCCGTGTTTTCTT -e AAGAAAACACGGCCGGGCGCGGT | \
awk '{sum += $1} END {print sum}' > mutantcount
find *.fastq.gz -type f | parallel -j+1 zgrep -c -e GTTATCAGTATATGTGTTTTCTTT -e AAGAAAACACATATACTGATAAC | \
awk '{sum += $1} END {print sum}' > wildtypecount

cat mutantcount
cat wildtypecount


