#!/bin/bash

# call: bash make_assembly.sh assembler goldstandard kmer blast_mode main_dir
assembler=$1
gold=$2
kmer=$3
blast_mode=$4
main_dir=$5

# assembler binary
rayBinary=/data/m_project_ws1415/progs/Ray-2.3.1
idbaBinary=/data/m_project_ws1415/progs/idba_ud-1.0.9/bin

# handle dirs
#main_dir=/data/m_project_ws1415
script_dir=$main_dir/scripts
assembler_dir=$main_dir/assembly/$assembler
blast_dir=$main_dir/blast
contigs_file=''
blast_name=''

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

# make metaVelvet assembler
if [ $assembler = 'metaVelvet' ]; then
    mkdir $assembler_dir/${gold}_${kmer}
    cd $assembler_dir/${gold}_${kmer}
    velveth . ${kmer} -fasta -short $blast_dir/S1_ID_${gold}.fa
    echo 'velveth . ${kmer} -fasta -short $blast_dir/S1_ID_${gold}.fa'
    velvetg . -exp_cov auto
    echo 'velvetg . -exp_cov auto'
    meta-velvetg .
    echo 'meta-velvetg .'
    cd $assembler_dir/
    contigs_file='contigs.fa'
fi

# make rayMeta assembler
if [ $assembler = 'rayMeta' ]; then
    $rayBinary/Ray -k ${kmer} -s $blast_dir/S1_ID_${gold}.fa -o $assembler_dir/${gold}_${kmer}
    echo '$rayBinary/Ray -k ${kmer} -s $blast_dir/S1_ID_${gold}.fa -o $assembler_dir/${gold}_${kmer}'
    cd $assembler_dir/
    contigs_file='Contigs.fasta'
fi

# make idba-ud
if [ $assembler = 'idba-ud' ]; then
    mkdir $assembler_dir/${gold}_${kmer}
    $idbaBinary/idba_ud -r $blast_dir/S1_ID_${gold}.fa -o $assembler_dir/${gold}_${kmer} --mink 19 --maxk ${kmer} --step 6 --seed_kmer 31
    echo '$idbaBinary/idba_ud -r $blast_dir/S1_ID_${gold}.fa -o $assembler_dir/${gold}_${kmer} --mink 19 --maxk ${kmer} --step 6 --seed_kmer 31'
    cd $assembler_dir/
    contigs_file='contig.fa'
fi

# make bowtie index
mkdir $assembler_dir/bowtie2_${gold}_${kmer}
cp $assembler_dir/${gold}_${kmer}/$contigs_file $assembler_dir/bowtie2_${gold}_${kmer}/contigs_${gold}_${kmer}.fa
cd $assembler_dir/bowtie2_${gold}_${kmer}
bowtie2-build -f contigs_${gold}_${kmer}.fa contigs_${gold}_${kmer}
echo 'bowtie2-build -f contigs_${gold}_${kmer}.fa contigs_${gold}_${kmer}'

# make bowtie alignment
# -f: fasta query  -r: one sequence per line
bowtie2 --threads 4 -f -x $assembler_dir/bowtie2_${gold}_${kmer}/contigs_${gold}_${kmer} -U $blast_dir/S1_ID_${gold}.fa -S contigs_${gold}_${kmer}.sam
echo 'bowtie2 --threads 4 -f -x $assembler_dir/bowtie2_${gold}_${kmer}/contigs_${gold}_${kmer} -U $blast_dir/S1_ID_${gold}.fa -S contigs_${gold}_${kmer}.sam'
samtools view -hb -F 4 contigs_${gold}_${kmer}.sam | samtools sort -n - > contigs_${gold}_${kmer}_sorted.bam
echo 'samtools view -hb -F 4 contigs_${gold}_${kmer}.sam | samtools sort -n - > contigs_${gold}_${kmer}_sorted.bam'
samtools view contigs_${gold}_${kmer}_sorted.bam > $assembler_dir/S0_${assembler}_${gold}_${kmer}.sam
echo 'samtools view contigs_${gold}_${kmer}_sorted.bam > $assembler_dir/S0_${assembler}_${gold}_${kmer}.sam'
cd $assembler_dir/

# make single line fasta file
python $script_dir/S1_single_line_fasta.py $assembler_dir/${gold}_${kmer}/$contigs_file $assembler_dir/S1_${assembler}_${gold}_${kmer}.fa
echo 'python $script_dir/S1_single_line_fasta.py $assembler_dir/${gold}_${kmer}/Contigs.fasta $assembler_dir/S1_${assembler}_${gold}_${kmer}.fa'

# make contig blast
python $script_dir/S2_start_blast.py $blast_mode $assembler_dir $assembler_dir/S1_${assembler}_${gold}_${kmer}.fa
echo 'python $script_dir/S2_start_blast.py $blast_mode $assembler_dir $assembler_dir/S1_${assembler}_${gold}_${kmer}.fa'

# trim blast file
python $script_dir/S3_trim_blast.py $assembler_dir/S2_${blast_name}_S1_${assembler}_${gold}_${kmer}.blastn $assembler_dir/S3_${blast_name}_${assembler}_${gold}_${kmer}.blastn
echo 'python $script_dir/S3_trim_blast.py $assembler_dir/S2_megablast_S1_${assembler}_${gold}_${kmer}.blastn $assembler_dir/S3_${assembler}_${gold}_${kmer}.blastn'

# remap contigs
python $script_dir/S4_merge_blast_sam.py $assembler_dir/S3_${blast_name}_${assembler}_${gold}_${kmer}.blastn $assembler_dir/S0_${assembler}_${gold}_${kmer}.sam $assembler_dir/S4_${blast_name}_${assembler}_${gold}_${kmer}.bsam
echo 'python $script_dir/S4_merge_blast_sam.py $assembler_dir/S3_${assembler}_${gold}_${kmer}.blastn $assembler_dir/S0_${assembler}_${gold}_${kmer}.sam $assembler_dir/S4_${assembler}_${gold}_${kmer}.bsam'


# bsam gi to tax
python $script_dir/S5_gi2tax.py $assembler_dir/S4_${blast_name}_${assembler}_${gold}_${kmer}.bsam $assembler_dir/S5_${blast_name}_${assembler}_${gold}_${kmer}_tax.bsam $blast_dir/gi_taxid_nucl.dmp
echo 'python $script_dir/S5_gi2tax.py $assembler_dir/S4_${assembler}_${gold}_${kmer}.bsam $assembler_dir/S5_${assembler}_${gold}_${kmer}_tax.bsam $blast_dir/gi_taxid_nucl.dmp'

# make base counts (gold counts)
# python count_base.py $blast_dir/S4_gold10_tax.fa $blast_dir/S6_gold10_count.cnt

# count assembler contigs
python $script_dir/S7_count_blastn.py $assembler_dir/S5_${blast_name}_${assembler}_${gold}_${kmer}_tax.bsam $assembler_dir/S7_${blast_name}_${assembler}_${gold}_${kmer}_count.cnt $blast_dir/S6_${gold}_count.cnt
echo 'python $script_dir/S7_count_blastn.py $assembler_dir/S5_${assembler}_${gold}_${kmer}_tax.bsam $assembler_dir/S7_${assembler}_${gold}_${kmer}_count.cnt $blast_dir/S6_${gold}_count.cnt'


