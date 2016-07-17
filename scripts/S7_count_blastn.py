#!/usr/bin/python
# script: S7_count_blast.py
# author: Daniel Desiro'
# usage: S7_count_blast.py <in_TAX.blastn/.bsam> <out_count.cnt> <in_count_base.cnt>

import sys
import re
import os



in_file = sys.argv[1]
out_file = sys.argv[2]
count_file = sys.argv[3]
countHash = {}
countHash['total'] = {}
countHash['true'] = {}
countHash['false'] = {}
with open(in_file, 'r') as blastn_in,\
     open(out_file, 'w') as count_out,\
     open(count_file, 'r') as count_in:
    
    # save count tax numbers
    notax = 0
    for line in count_in:
        line = line.strip()
        taxID, count = re.split(r'\t+',line)
        if taxID != 'notax':
            for type in countHash.keys():
                if type == 'total':
                    countHash[type][taxID] = count
                else:
                    countHash[type][taxID] = 0
        else:
            notax = int(count)
    
    # check blastn
    notaxBlasted = 0
    saveType = ''
    for line in blastn_in:
        line = line.strip()
        queryTaxID, subjectTaxID = re.split(r'\t+',line)[:2]
        if not re.search(r'tax\|tax\|',queryTaxID):
            # check false
            if re.search(r'tax\|tax\|',subjectTaxID) or \
             re.search(r'tax\|([0-9]+)\|',queryTaxID).group(1) != \
             re.search(r'tax\|([0-9]+)\|',subjectTaxID).group(1):
                saveType = 'false'
            # check true
            else:
                saveType = 'true'
            queryTaxNum = re.search(r'tax\|([0-9]+)\|',queryTaxID).group(1)
            taxCounter = countHash[saveType].get(queryTaxNum, 0)
            countHash[saveType][queryTaxNum] = taxCounter + 1
        else:
            notaxBlasted += 1
    
    # write data
    notaxNoclass = notax - notaxBlasted
    for key in sorted(countHash['total'].keys(), key=int):
        unclassified = int(countHash['total'][key]) - (int(countHash['true'][key]) + int(countHash['false'][key]))
        count_out.write('%s\t%s\t%s\t%s\t%s\n' % (key, countHash['total'][key], countHash['true'][key], \
                                                  countHash['false'][key], unclassified))
    count_out.write('notax\t%s\t0\t%s\t%s' % (notax, notaxBlasted, notaxNoclass))

