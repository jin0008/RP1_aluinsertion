# RP1_aluinsertion

The linux program grep to search FASTQ files for the 5' junction of between the reference sequence of exon 4 and the beginning of the Alu insertion in RP1 gene.

Most files without the insertion return a count of "0" though rarely a false-positive read count of 1 or 2 detected in minority of wildtype samples depending on the depth of coverage and the method of sequencing such as targeted, whole exome, or whole genome.

In the datafolder to execute this command to grep Alu-insertion in exon 4 of RP1

This RP1 Alu insertion with other truncated variant has been known to cause autosomal recessive macular dystrophy with retinitis pigmentosa.

This Alu insertion in RP1 gene seems to be frequently observed in East Asian (Korean, Japanese, ...), probably founder mutation.


## Prerequisites (Ubuntu) 
## GNU parallels and python is required.
## The name of fastq.gz files should be ${Sample}_R1.fast.gz and ${Sample}_R2.fastq.gz

#### 
```
sudo apt install moreutils
sudo apt install parallel
sudo apt-get install agrep
pip install matplotlib jinja2
```

## Install
```
git clone https://github.com/jin0008/RP1_aluinsertion.git
```

## Set your PATH permanently
```
export PATH="$PATH:/where/to/RP1_aluinsertion"
```

## To run

Run this bash script in the directory with fastq.gz files.

This code runs with multiple samples.

```
python RP1_alu.py
```

### Interpretation of results (See. IR_AI_029.RP1_Alu_analysis.html files)

#### VAF < 0.1 : No AluY insertion was found in exon 4 of RP1 at chr8:54627934 position (hg38)

#### 0.1 <= VAF < 0.3 : AluY insertion was suspected in exon 4 of RP1 at chr8:54627934 position (hg38). Please recheck by visualizing AluY sequence at chr8:54627934 position (hg19).

#### VAF >= 0.3 : AluY insertion was detected in exon 4 of RP1 at chr8:54627934 position (hg38).

![alt text](https://github.com/jin0008/RP1_aluinsertion/blob/master/RP1.jpg?raw=true) 


#### Or you can directly check this common Alu insertion in Integative Genomics Viewer (Broad Institute)
hg19 position: chr8:55540494

hg38 position: chr8:54627934

Please turn on "show sof-clipped bases" in the Preference-Alignments of Integrative Genomics Viewer.

![alt text](https://github.com/jin0008/RP1_aluinsertion/blob/master/IGV.jpg?raw=true) 

![alt text](https://github.com/jin0008/RP1_aluinsertion/blob/master/AluinsertionIGV.jpg?raw=true)



In referring to work done using RP1 alu grep program, please cite:

Won D, Hwang JY, Shim Y, Byeon SH, Lee J, Lee CS, Kim M, Lim HT, Choi JR, Lee ST, Han J.
In Silico identification of a common mobile element insertion in exon 4 of RP1. 
Sci Rep. 2021 June 28;11(1):13381. 
