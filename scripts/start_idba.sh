#!/bin/bash

# call jobs
main_dir=/data/m_project_ws1415/nohup
script_dir=/data/m_project_ws1415/scripts

assembler='idba-ud'
goldstandard='gold10'
mkdir $main_dir/i1031; cd $main_dir/i1031
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 31 dcmega &
mkdir $main_dir/i1043; cd $main_dir/i1043
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 43 dcmega &
mkdir $main_dir/i1055; cd $main_dir/i1055
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 55 dcmega &
mkdir $main_dir/i1067; cd $main_dir/i1067
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 67 dcmega &
mkdir $main_dir/i1079; cd $main_dir/i1079
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 79 dcmega &
mkdir $main_dir/i1091; cd $main_dir/i1091
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 91 dcmega &

assembler='idba-ud'
goldstandard='gold100'
mkdir $main_dir/i10031; cd $main_dir/i10031
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 31 dcmega &
mkdir $main_dir/i10043; cd $main_dir/i10043
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 43 dcmega &
mkdir $main_dir/i10055; cd $main_dir/i10055
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 55 dcmega &
mkdir $main_dir/i10067; cd $main_dir/i10067
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 67 dcmega &
mkdir $main_dir/i10079; cd $main_dir/i10079
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 79 dcmega &
mkdir $main_dir/i10091; cd $main_dir/i10091
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 91 dcmega &

assembler='idba-ud'
goldstandard='gold1000'
mkdir $main_dir/i100031; cd $main_dir/i100031
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 31 dcmega &
mkdir $main_dir/i100043; cd $main_dir/i100043
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 43 dcmega &
mkdir $main_dir/i100055; cd $main_dir/i100055
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 55 dcmega &
mkdir $main_dir/i100067; cd $main_dir/i100067
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 67 dcmega &
mkdir $main_dir/i100079; cd $main_dir/i100079
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 79 dcmega &
mkdir $main_dir/i100091; cd $main_dir/i100091
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 91 dcmega &
