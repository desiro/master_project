#!/usr/bin/python
# script: add_id.py
# author: Daniel Desiro'
# usage: python add_id.py <blast_in> <blast_out>
# files: 
# description: removes duplicate blasts and remove ID num

import sys
import re
import os


input = sys.argv[1]
output = sys.argv[2]
baseQueryID = ''
with open(input, 'r') as raw:
    with open(output, 'w') as out:
        for line in raw:
            line = line.strip()
            if not re.match(r'\#',line):
                split_line = re.split(r'\t+',line)
                # get new base query id (only  save first blast result)
                if split_line[0] != baseQueryID:
                    baseQueryID = split_line[0]
                    split_line[0] = re.sub(r'ID\|[0-9]+\|', '', split_line[0])
                    # make new line
                    new_line = split_line[0]
                    for item in split_line[1:]:
                        new_line = '%s\t%s' % (new_line, item)
                    # write line
                    out.write('%s\n' % new_line)



