#!/usr/bin/python
# script: S1_add_id.py
# author: Daniel Desiro'
# usage: python add_id.py <fasta_in> <fasta_out>
# files: 
# description: adds ID nums to fasta names

import sys
import re
import os


input = sys.argv[1]
output = sys.argv[2]
first = True
old_id = ''
id_num = 0
with open(input, 'r') as raw:
    with open(output, 'w') as out:
        for line in raw:
            line = line.strip()
            if re.match(r'>',line):
            #if not re.match(r'\#',line):
                split_line = re.split(r'\s+',line)
                # check for first line in file
                if first:
                    old_id = split_line[0]
                    first = False
                # check if we have new query ID
                if old_id != split_line[0]:
                    old_id = split_line[0]
                    id_num = 0
                id_num += 1
                # add ID num
                split_line[0] = '%sID|%s|' % (split_line[0], id_num)
                # make new line
                new_line = split_line[0]
                for item in split_line[1:]:
                    new_line = '%s %s' % (new_line, item)
                # write line
                out.write('%s\n' % new_line)
            else:
                # write data line
                out.write('%s\n' % line)




