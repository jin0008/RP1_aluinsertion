dir.create('split')
TotalThread=as.numeric ( Sys.getenv ('TotalThread') )


fqpattern='.fastq.gz$'

fqs=list.files(pattern=fqpattern)
samples = levels(as.factor(gsub('.', '', gsub('_$', '', gsub('R1.fastq.gz$|R2.fastq.gz$', '', fqs)), fixed=T)))
writeLines (samples, 'samples.txt')

for (i in 1:length(samples)){
 Sample=samples[i]
 samplefq=fqs[grepl(Sample,fqs)]
 fq1=samplefq[grepl('R1.fastq.gz',samplefq)][1]
 fq2=samplefq[grepl('R2.fastq.gz',samplefq)][1]
 system (paste0 ( 'zcat ', fq1, ' ', fq2, ' | sed -n \'2~4p\' > ', Sample, '.seqs' ))
 reads = as.numeric (system (paste0 ('wc -l ', Sample, '.seqs | cut -d\' \' -f1' ), intern=T))
 bin = reads / TotalThread
 for (p in 1:TotalThread){ 
  threadtxt=sprintf ('%06d', p)
  SampleThread=paste0 (Sample, '.thread', threadtxt)    
  binstart= ceiling((p - 1) * bin) +1
  binend = min (ceiling(p * bin), reads)
  system (paste0('awk \'NR>=', binstart, '&&NR<=', binend,'\' ', Sample, '.seqs > split/', Sample, '.', threadtxt ,'.seqs'))
 }
 file.remove(paste0('split/', Sample, '.mutantcounts1'))
 file.remove(paste0('split/', Sample, '.mutantcounts2'))
}

