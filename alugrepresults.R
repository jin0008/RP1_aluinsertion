samples = readLines ('samples.txt')
for (i in 1:length(samples)){
 Sample=samples[i]
 mutcount1=sum(as.numeric(readLines(paste0('split/',Sample, '.mutantcounts1'))))
 mutcount2=sum(as.numeric(readLines(paste0('split/',Sample, '.mutantcounts2'))))
 wildcount1=sum(as.numeric(readLines(paste0('split/',Sample, '.wildcounts1'))))
 wildcount2=sum(as.numeric(readLines(paste0('split/',Sample, '.wildcounts2'))))
 writeLines (paste0 ('pattern\tcounts\nACCGCGCCCGGCC(GTGTTTTCTTTGG)\t',mutcount1, '\n(CCAAAGAAAACAC)GGCCGGGCGCGGT\t', mutcount2, '\nGTTATCAGTATAT(GTGTTTTCTTTGG)\t', wildcount1, '\n(CCAAAGAAAACAC)ATATACTGATAAC\t', wildcount2), paste0(Sample, '.alugrep.results.tsv'))
}

mutcounttotal= mutcount1+ mutcount2
wildcounttotal= wildcount1+ wildcount2
VAF= mutcounttotal / (mutcounttotal+ wildcounttotal)

if (VAF < 0.1) writeLines ('No AluY insertion was found in exon 4 of RP1 at 8:55540494 position (hg19)', paste0(Sample, '.alugrep.final.results.txt'))
if (VAF >= 0.1 & VAF < 0.3) writeLines ('AluY insertion was suspected in exon 4 of RP1 at 8:55540494 position (hg19). Please recheck by visualizing AluY sequence at 8:55540494 position (hg19).', paste0(Sample, '.alugrep.final.results.txt'))
if (VAF >= 0.3) writeLines ('AluY insertion was detected in exon 4 of RP1 at 8:55540494 position (hg19).', paste0(Sample, '.alugrep.final.results.txt'))
