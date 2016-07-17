#!/usr/bin/python
# script: S5_gi2tax.py
# author: Daniel Desiro'
# usage: S5_gi2tax.py <in-GI.blastn/.bsam/.fa> <out-TAX.blastn/.bsam/.fa> <in-gi2tax.dmp>


import sys
import re
import os


# ftp://ftp.ncbi.nih.gov/pub/taxonomy/
gi_in_file = sys.argv[1]
tax_out_file = sys.argv[2]
gi2tax_in_file = sys.argv[3]
gi2taxHash = {}
fasta_in = False
blastn_in = False
bsam_in = False
# save important gi numbers and ref tax number
with open(gi_in_file, 'r') as gi_in,\
     open(gi2tax_in_file, 'r') as gi2tax_in:
    # check file extension
    if (os.path.splitext(gi_in_file)[1] == '.fa'):
        fasta_in = True
    elif (os.path.splitext(gi_in_file)[1] == '.blastn'):
        blastn_in = True
    elif (os.path.splitext(gi_in_file)[1] == '.bsam'):
        blastn_in = True
        bsam_in = True
    
    # save important gi numbers from input-blast-GI-file.blastn into gi2taxHash
    print('------------------------------------')
    print('Save relevant gi numbers:')
    for i,line in enumerate(gi_in):
        if (i % 1000000) == 0:
            print('Status: Line %s done ...' % i)
        line = line.strip()
        if blastn_in and not (re.match(r'\#',line) or (line == False)):
            queryGiID, subjectGiID = re.split(r'\t+',line)[:2]
            subjectGiNum = re.search(r'gi\|([0-9]+)\|',subjectGiID).group(1)
            gi2taxHash[subjectGiNum] = 'tax'
        elif fasta_in and re.match(r'>',line) :
            queryGiID = line
        elif not (fasta_in or blastn_in):
            print('Error: Unknown file extension ...')
            sys.exit()
        queryGiNum = re.search(r'gi\|([0-9]+)\|',queryGiID).group(1)
        gi2taxHash[queryGiNum] = 'tax'
    
    # get tax numbers for gi2taxHash from input-gi2tax-reference-file.dmp
    print('------------------------------------')
    print('Save relevant tax numbers:')
    for i,line in enumerate(gi2tax_in):
        if (i % 10000000) == 0:
            print('Status: Line %s done ...' % i)
        line = line.strip()
        giID, taxID = re.split(r'\t',line)[:2]
        hashItem = gi2taxHash.get(giID, '')
        if hashItem == 'tax':
            gi2taxHash[giID] = taxID

with open(gi_in_file, 'r') as gi_in,\
     open(tax_out_file, 'w') as tax_out:
    # transform gi numbers to tax numbers and set new ID flag
    print('------------------------------------')
    print('Change gi to tax:')
    for i,line in enumerate(gi_in):
        if (i % 1000000) == 0:
            print('Status: Line %s done ...' % i)
        line = line.strip()
        line_tail = ''
        tax_subjectID = ''
        tax_queryID = ''
        if blastn_in and not (re.match(r'\#',line) or (line == False)):
            if blastn_in and not bsam_in:
                queryGiID, subjectGiID, id, len, mM, gapO, qStart, qEnd, sStart, sEnd, eVal, bScore = re.split(r'\t+',line)
                line_tail = '\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s' % (id, len, mM, gapO, qStart, qEnd, sStart, sEnd, eVal, bScore)
            elif blastn_in and bsam_in:
                queryGiID, subjectGiID = re.split(r'\t+',line)
                line_tail = ''
            # get subject GI
            subjectGiNum = re.search(r'gi\|([0-9]+)\|',subjectGiID).group(1)
            # get subject TAX
            subjectTaxID = 'tax|%s|' % gi2taxHash.get(subjectGiNum, '')
            # check if a corresponding GI number was found
            if subjectTaxID == 'tax|tax|':
                print('Warning: No reference GI for %s found!' % subjectGiNum)
            # transform subject GI ID into TAX ID
            tax_subjectID = '\t%s' % re.sub(r'gi\|[0-9]+\|', subjectTaxID, subjectGiID)
        elif fasta_in and re.match(r'>',line):
            queryGiID = line
        elif fasta_in and not re.match(r'>',line):
            continue
        elif not (fasta_in or blastn_in):
            print('Error: Unknown file extension ...')
            sys.exit()
        # get query GI
        queryGiNum = re.search(r'gi\|([0-9]+)\|',queryGiID).group(1)
        # get query TAX
        queryTaxID = 'tax|%s|' % gi2taxHash.get(queryGiNum, '')
        # check if a corresponding GI number was found
        if queryTaxID == 'tax|tax|':
            print('Warning: No reference GI for %s found!' % queryGiNum)
        # transform query GI ID into TAX ID
        tax_queryID = re.sub(r'gi\|[0-9]+\|', queryTaxID, queryGiID)
        # write to file
        tax_out.write('%s%s%s\n' % (tax_queryID, tax_subjectID, line_tail))




