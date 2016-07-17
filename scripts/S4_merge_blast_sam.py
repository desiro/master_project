#!/usr/bin/python
# script: S4_merge_blast_sam.py
# author: Daniel Desiro'
# usage: python S4_merge_blast_sam.py <blast_in> <sam_in> <bsam_out>
# files: 
# description: merges blast and sam output for comparison, output file should have the extension bsam

import sys
import re
import os


blast_file = sys.argv[1]
sam_file = sys.argv[2]
blast_sam_out = sys.argv[3]
contigMapHash = {}
# make contig mapping
with open(blast_file, 'r') as blast_in:
    for line in blast_in:
        line = line.strip()
        queryID, subjectID = re.split(r'\t+',line)[:2]
        contigMapHash[queryID] = subjectID

# remap sam file
with open(sam_file, 'r') as sam_in,\
     open(blast_sam_out, 'w') as bs_out:
    for line in sam_in:
        line = line.strip()
        queryID, dummy, subjectID = re.split(r'\t+',line)[:3]
        hashItem = contigMapHash.get(subjectID, 'gi|0000|')
        bs_out.write('%s\t%s\n' % (queryID, hashItem))

