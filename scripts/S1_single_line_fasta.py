#!/usr/bin/python
# script: S1_single_line_fasta.py
# author: Daniel Desiro'
# usage: python add_id.py <fasta_in> <fasta_out>
# files: 
# description: merges multi line FASTA files

import sys
import re
import os


input = sys.argv[1]
output = sys.argv[2]
with open(input, 'r') as raw:
    with open(output, 'w') as out:
        nuc_string = ''
        first = True
        for line in raw:
            line = line.strip()
            if re.match(r'>',line):
                if not first:
                    out.write('%s\n' % nuc_string)
                nuc_string = ''
                out.write('%s\n' % line)
                first = False
            else:
                nuc_string = '%s%s' %(nuc_string, line)
        out.write('%s\n' % nuc_string)
