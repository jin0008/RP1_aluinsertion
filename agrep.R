pThread=as.numeric ( Sys.getenv ('pThread') )
threadtxt=sprintf ('%06d', pThread)
samples = readLines ('samples.txt')


for (i in 1:length(samples)){
 Sample=samples[i]
 seqfile=paste0('split/', Sample, '.', threadtxt, '.seqs')
 system (paste0('agrep -1 -D2 -I2 -c -e \'ACCGCGCCCGGCC(GTGTTTTCTTTGG)\' ',seqfile, ' >> split/',Sample, '.mutantcounts1'))
 system (paste0('agrep -1 -D2 -I2 -c -e \'(CCAAAGAAAACAC)GGCCGGGCGCGGT\' ',seqfile, ' >> split/',Sample, '.mutantcounts2'))
 system (paste0('agrep -1 -D2 -I2 -c -e \'GTTATCAGTATAT(GTGTTTTCTTTGG)\' ',seqfile, ' >> split/',Sample, '.wildcounts1'))
 system (paste0('agrep -1 -D2 -I2 -c -e \'(CCAAAGAAAACAC)ATATACTGATAAC\' ',seqfile, ' >> split/',Sample, '.wildcounts2'))
}
