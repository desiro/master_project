#!/usr/bin/python
# script: S6_count_base.py
# author: Daniel Desiro'
# usage: S6_count_base.py <in_TAX.fa> <out_count_base.cnt>

import sys
import re
import os



in_file = sys.argv[1]
out_file = sys.argv[2]
countHash = {}
with open(in_file, 'r') as fasta_in,\
     open(out_file, 'w') as count_out:
    # count tax occurrences
    notax = 0
    for line in fasta_in:
        line = line.strip()
        if re.match(r'>',line):
            if not re.search(r'tax\|tax\|',line):
                taxNum = re.search(r'tax\|([0-9]+)\|',line).group(1)
                taxCounter = countHash.get(taxNum, 0)
                countHash[taxNum] = taxCounter + 1
            else:
                notax += 1
    # write tax occurrences
    #count_out.write('taxID\tcount\n')
    for key in sorted(countHash.keys(), key=int):
        count_out.write('%s\t%s\n' % (key, countHash[key]))
    count_out.write('notax\t%s\n' % notax)
