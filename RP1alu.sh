
echo ""
echo "RP1-Alu grep search start"
echo ""

for sample_id in *_R1.fastq.gz;
do SAMPLE=${sample_id%%_R1.fastq.gz}; \

find $SAMPLE*.fastq.gz -type f | parallel -j+1 zgrep -c -e ACCGCGCCCGGCCGTGTTTTCTTTGG -e CCAAAGAAAACACGGCCGGGCGCGGT \
| awk '{sum += $1} END {print sum}' > $SAMPLE.mutantcount;

find $SAMPLE*.fastq.gz -type f | parallel -j+1 zgrep -c -e GTTATCAGTATATGTGTTTTCTTTGG -e CCAAAGAAAACACATATACTGATAAC \
| awk '{sum += $1} END {print sum}' > $SAMPLE.wildtypecount;

paste -d+ $SAMPLE.mutantcount $SAMPLE.wildtypecount | bc > $SAMPLE.depth;

paste $SAMPLE.mutantcount $SAMPLE.depth | awk '{print($1/$2)}' > $SAMPLE.VAF;


value=( $(<$SAMPLE.VAF));
X=0.1;
Y=0.3;

if [ $(echo " $value < $X" | bc) -eq 1 ]; then
	echo "VAF < 0.1 : No AluY insertion was found in exon 4 of RP1 at 8:55540494 position (hg19)" > $SAMPLE.RP1_Alu.txt
elif [ $(echo " $value >= $Y" | bc) -eq 1 ]; then
	echo "0.1 <= VAF < 0.3 : AluY insertion was suspected in exon 4 of RP1 at 8:55540494 position (hg19). Please recheck by visualizing AluY sequence at 8:55540494 position (hg19)" > $SAMPLE.RP1_Alu.txt
else
	echo "VAF >= 0.3 : AluY insertion was detected in exon 4 of RP1 at 8:55540494 position (hg19)" > $SAMPLE.RP1_Alu.txt

fi

done;





