#!/usr/bin/python
# script: fastq2fasta.py
# author: Daniel Desiro'
# usage: fastq2fasta.py <input-ziped-fastq-file.fastq.gz> <output-unziped-fasta-file.fasta>
# files: input-ziped-fastq-file.fastq.gz    -> input gold ziped fastq file
#        output-unziped-fasta-file.fasta    -> output gold unziped fasta file

import sys 
import gzip

with gzip.open(sys.argv[1], "r") as fq:
    with open(sys.argv[2], "w") as fa:
        i = 1
        for line in fq:
            if i % 4 == 1:
                linex = line.replace("@",">")
                fa.write(linex)
            elif i % 4 == 2:
                fa.write(line)
            i += 1

