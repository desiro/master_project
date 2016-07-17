#!/bin/bash

# call: bash make_blast.sh goldstandard goldstandard.fa blast_mode main_dir
# blast modes: dcmega, blastn, mega
gold=$1
gold_file=$2
blast_mode=$3
main_dir=$4

# handle dirs
#main_dir=/data/m_project_ws1415
script_dir=$main_dir/scripts
blast_dir=$main_dir/blast
blast_name=''
fastq_gz=false

# blast name
if [ $blast_mode = 'blastn' ]; then
    blast_name='blastn'
fi
if [ $blast_mode = 'dcmega' ]; then
    blast_name='dc-megablast'
fi
if [ $blast_mode = 'mega' ]; then
    blast_name='megablast'
fi

# unzip fastq file and transform to fasta
if [ $fastq_gz = true ]; then
    python $script_dir/fastq2fasta.py $gold_file $blast_dir/S0_${gold}.fa
    echo 'python $script_dir/fastq2fasta.py $gold_file $blast_dir/S0_${gold}.fa'
else
    cp $gold_file $blast_dir/S0_${gold}.fa
    echo 'cp $gold_file $blast_dir/S0_${gold}.fa'
fi

# step 1 - add ID to gold fasta files
python $script_dir/S1_add_id.py $blast_dir/S0_${gold}.fa $blast_dir/S1_ID_${gold}.fa
echo 'python $script_dir/S1_add_id.py $blast_dir/S0_${gold}.fa $blast_dir/S1_ID_${gold}.fa'

# step 2 - run blastn on ID gold fasta files (split first, then individually call blastn on small fasta files)
# automatic output: S2_<file_base>.blastn
python $script_dir/S2_start_blast.py $blast_mode $blast_dir $blast_dir/S1_ID_${gold}.fa
echo 'python $script_dir/S2_start_blast.py $blast_mode $blast_dir $blast_dir/S1_ID_${gold}.fa'

# step 3 - trim blastn files according to ID, only keep first entry with the same ID tag
python $script_dir/S3_trim_blast.py $blast_dir/S2_${blast_name}_S1_ID_${gold}.blastn $blast_dir/S3_${blast_name}_trim_${gold}.blastn
echo 'python $script_dir/S3_trim_blast.py $blast_dir/S2_${blast_name}_S1_ID_${gold}.blastn $blast_dir/S3_${blast_name}_trim_${gold}.blastn'

# step 4 - transform gi numbers into tax numbers for fasta files
python $script_dir/S5_gi2tax.py $blast_dir/S0_${gold}.fa $blast_dir/S4_${gold}_tax.fa $blast_dir/gi_taxid_nucl.dmp
echo 'python $script_dir/S5_gi2tax.py $blast_dir/S0_${gold}.fa $blast_dir/S4_${gold}_tax.fa $blast_dir/gi_taxid_nucl.dmp'

# step 5 - transform gi numbers into tax numbers for blastn files
python $script_dir/S5_gi2tax.py $blast_dir/S3_${blast_name}_trim_${gold}.blastn $blast_dir/S5_${blast_name}_trim_${gold}_tax.blastn $blast_dir/gi_taxid_nucl.dmp
echo 'python $script_dir/S5_gi2tax.py $blast_dir/S3_${blast_name}_trim_${gold}.blastn $blast_dir/S5_${blast_name}_trim_${gold}_tax.blastn $blast_dir/gi_taxid_nucl.dmp'

# step 6 - make base counts (gold counts)
python $script_dir/S6_count_base.py $blast_dir/S4_${gold}_tax.fa $blast_dir/S6_${gold}_count.cnt
echo 'python $script_dir/S6_count_base.py $blast_dir/S4_${gold}_tax.fa $blast_dir/S6_${gold}_count.cnt'

# step 7 - make blastn counts
python $script_dir/S7_count_blastn.py $blast_dir/S5_${blast_name}_trim_${gold}_tax.blastn $blast_dir/S7_${blast_name}_${gold}_count.cnt $blast_dir/S6_${gold}_count.cnt
echo 'python $script_dir/S7_count_blastn.py $blast_dir/S5_${blast_name}_trim_${gold}_tax.blastn $blast_dir/S7_${blast_name}_${gold}_count.cnt $blast_dir/S6_${gold}_count.cnt'


