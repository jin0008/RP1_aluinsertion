import os
import sys
FASTQ1=sys.argv[1]
FASTQ2=sys.argv[2]

os.system("find FASTQ1 FASTQ2 -type f | parallel -j+1 zgrep -c -e ACCGCGCCCGGCC(GTGTTTTCTTTGG){s<=1} -e (CCAAAGAAAACAC){s<=1}GGCCGGGCGCGGT \
| awk '{sum += $1} END {print sum}' > mutantcount")
os.system("find FASTQ1 FASTQ2  -type f | parallel -j+1 zgrep -c -e GTTATCAGTATATGTGTTTTCTTTGG{s<=1} -e CCAAAGAAAACACATATACTGATAAC{s<=1} \
| awk '{sum += $1} END {print sum}' > wildtypecount")

f1=open("mutantcount", "r")
f2=open("wildtypecount", "r")
x=float(f1.read())
y=float(f2.read())
z=x/(x+y)
print(z)

if z < 0.1 :
	print('no AluY insertion in RP1 exon 4 was detect')
elif z >=0.3 :
	print('AluY insertion in RP1 exon 4 was detected!!')
else :
	print('AluY insertion in RP1 exon 4 was suspected!! please confirm the AluY in RP1 exon4 by Integrative Genomics Viewer')