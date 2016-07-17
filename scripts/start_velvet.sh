#!/bin/bash

# call jobs
main_dir=/data/m_project_ws1415/nohup
script_dir=/data/m_project_ws1415/scripts

assembler='metaVelvet'
goldstandard='gold10'
mkdir $main_dir/v1031; cd $main_dir/v1031
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 31 dcmega &
mkdir $main_dir/v1043; cd $main_dir/v1043
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 43 dcmega &
mkdir $main_dir/v1055; cd $main_dir/v1055
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 55 dcmega &
mkdir $main_dir/v1067; cd $main_dir/v1067
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 67 dcmega &
mkdir $main_dir/v1079; cd $main_dir/v1079
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 79 dcmega &
mkdir $main_dir/v1091; cd $main_dir/v1091
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 91 dcmega &

assembler='metaVelvet'
goldstandard='gold100'
mkdir $main_dir/v10031; cd $main_dir/v10031
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 31 dcmega &
mkdir $main_dir/v10043; cd $main_dir/v10043
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 43 dcmega &
mkdir $main_dir/v10055; cd $main_dir/v10055
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 55 dcmega &
mkdir $main_dir/v10067; cd $main_dir/v10067
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 67 dcmega &
mkdir $main_dir/v10079; cd $main_dir/v10079
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 79 dcmega &
mkdir $main_dir/v10091; cd $main_dir/v10091
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 91 dcmega &

assembler='metaVelvet'
goldstandard='gold1000'
mkdir $main_dir/v100031; cd $main_dir/v100031
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 31 dcmega &
mkdir $main_dir/v100043; cd $main_dir/v100043
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 43 dcmega &
mkdir $main_dir/v100055; cd $main_dir/v100055
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 55 dcmega &
mkdir $main_dir/v100067; cd $main_dir/v100067
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 67 dcmega &
mkdir $main_dir/v100079; cd $main_dir/v100079
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 79 dcmega &
mkdir $main_dir/v100091; cd $main_dir/v100091
nohup bash $script_dir/make_assembly.sh $assembler $goldstandard 91 dcmega &
