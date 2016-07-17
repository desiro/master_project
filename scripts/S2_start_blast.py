#!/usr/bin/python
# Script: outputProcessing.py
# Author: Daniel Desiro'
# Call: S2_start_blast.py <dcmega/blastn/mega> <out dir> <in FASTA>

###############################################################################
## Runs blast for different gold standards
## gold10, gold100, gold1000
## first transforms ziped fastq goldstandard files to unziped fasta files
## then runs fasta files with blast
###############################################################################

import sys
import re
import shutil
import os


# path to project folder
#m_proj = '/data/m_project_ws1415'
# path to blast db
blast_db = '/data/db/blastdb/nt'
# path to python fastq to fasta converter
#fq_to_fa = '%s/python/fastq2fasta.py' % m_proj
task = 'blastn'


task = sys.argv[1]
out_dir = os.path.abspath(sys.argv[2])
fasta_file = sys.argv[3]
if task == 'dcmega':
    task = 'dc-megablast'
elif task == 'blastn':
    task = 'blastn'
elif task == 'mega':
    task = 'megablast'
else:
    task = 'megablast'

## parameter handling
base_name = os.path.basename(fasta_file)
base_name = os.path.splitext(base_name)[0]
base_name = os.path.splitext(base_name)[0]
tmp_dir = '%s/tmp_%s_%s' % (out_dir, task, base_name)
tmp_fasta = '%s/%s.fa' % (tmp_dir, base_name)
tmp_fa_split = '%s/fa_split_%s' % (tmp_dir, base_name)
tmp_bl_split = '%s/bl_split_%s' % (tmp_dir, base_name)
fa_split_base = '%s/%s.fa.' % (tmp_fa_split, base_name)
bl_split_base = '%s/%s.bl.' % (tmp_bl_split, base_name)

## make tmp folder
print('Status: make tmp folder ...')
if not os.path.isdir(tmp_dir): os.mkdir(tmp_dir)
if not os.path.isdir(tmp_fa_split): os.mkdir(tmp_fa_split)
if not os.path.isdir(tmp_bl_split): os.mkdir(tmp_bl_split)

## transform fastq to fasta
#if not os.path.isfile(tmp_fasta):
#    os.system('python %s %s %s' % (fq_to_fa, fasta_file, tmp_fasta))

## unzip
print('Status: unzip fasta files ...')
if not os.path.isfile(tmp_fasta) and os.path.splitext(fasta_file)[1] == '.gz':
    print('zcat %s > %s' % (fasta_file, tmp_fasta))
    os.system('zcat %s > %s' % (fasta_file, tmp_fasta))
else:
    tmp_fasta = fasta_file

## split fasta files
print('Status: split fasta files ...')
print('split -l 200000 -d %s %s' % (tmp_fasta, fa_split_base))
os.system('split -l 200000 -d %s %s' % (tmp_fasta, fa_split_base))

## run blast
print('Status: run blast ...')
for part in sorted(os.listdir(tmp_fa_split)):
    ext = part.split('.')[-1]
    print('blastn -task %s -db %s -query %s/%s -out %s%s -outfmt 6 -num_threads 4 -evalue 10 -max_target_seqs 1' % (task, blast_db, tmp_fa_split, part, bl_split_base, ext))
    os.system('blastn -task %s -db %s -query %s/%s -out %s%s -outfmt 6 -num_threads 4 -evalue 10 -max_target_seqs 1' % (task, blast_db, tmp_fa_split, part, bl_split_base, ext))

## merge blasts
print('Status: merge strings ...')
merge_string = ''
for part in sorted(os.listdir(tmp_bl_split)):
    merge_string = '%s%s/%s ' % (merge_string, tmp_bl_split, part)
print('cat %s> %s/S2_%s_%s.blastn' % (merge_string, out_dir, task, base_name))
os.system('cat %s> %s/S2_%s_%s.blastn' % (merge_string, out_dir, task, base_name))

## remove splits
#print('Status: remove tmp folder ...')
#shutil.rmtree(tmp_fa_split, True)
#shutil.rmtree(tmp_bl_split, True)

print('Status: done ...')
    
    
