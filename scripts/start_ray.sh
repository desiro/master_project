#!/bin/bash

# call jobs
main_dir=/data/m_project_ws1415/nohup
script_dir=/data/m_project_ws1415/scripts

assembler='rayMeta'
goldstandard='gold10'
mkdir $main_dir/r1031; cd $main_dir/r1031
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 31 dcmega &
mkdir $main_dir/r1043; cd $main_dir/r1043
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 43 dcmega &
mkdir $main_dir/r1055; cd $main_dir/r1055
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 55 dcmega &
mkdir $main_dir/r1067; cd $main_dir/r1067
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 67 dcmega &
mkdir $main_dir/r1079; cd $main_dir/r1079
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 79 dcmega &
mkdir $main_dir/r1091; cd $main_dir/r1091
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 91 dcmega &

assembler='rayMeta'
goldstandard='gold100'
mkdir $main_dir/r10031; cd $main_dir/r10031
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 31 dcmega &
mkdir $main_dir/r10043; cd $main_dir/r10043
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 43 dcmega &
mkdir $main_dir/r10055; cd $main_dir/r10055
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 55 dcmega &
mkdir $main_dir/r10067; cd $main_dir/r10067
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 67 dcmega &
mkdir $main_dir/r10079; cd $main_dir/r10079
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 79 dcmega &
mkdir $main_dir/r10091; cd $main_dir/r10091
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 91 dcmega &

assembler='rayMeta'
goldstandard='gold1000'
mkdir $main_dir/r100031; cd $main_dir/r100031
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 31 dcmega &
mkdir $main_dir/r100043; cd $main_dir/r100043
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 43 dcmega &
mkdir $main_dir/r100055; cd $main_dir/r100055
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 55 dcmega &
mkdir $main_dir/r100067; cd $main_dir/r100067
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 67 dcmega &
mkdir $main_dir/r100079; cd $main_dir/r100079
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 79 dcmega &
mkdir $main_dir/r100091; cd $main_dir/r100091
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 91 dcmega &
