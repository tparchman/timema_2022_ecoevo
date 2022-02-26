#!/bin/bash

##########################################################################################
## T5_PC cleaning 
##########################################################################################

/working/jahner/tapioca/src/tap_contam_analysis --db  /archive/parchman_lab/rawdata_to_backup/contaminants/illumina_oligos --pct 20 /working/parchman/Tcristinae_2022/T5_S1_L001_R1_001.fastq > T5_PC.readstofilter.ill.txt 

echo "Illumina filtering done for lane 1"

/working/jahner/tapioca/src/tap_contam_analysis --db /archive/parchman_lab/rawdata_to_backup/contaminants/phix174 --pct 80 /working/parchman/Tcristinae_2022/T5_S1_L001_R1_001.fastq > T5_PC.readstofilter.phix.txt 

echo "PhiX filtering done for lane 1"


/working/jahner/tapioca/src/tap_contam_analysis --db  /archive/parchman_lab/rawdata_to_backup/contaminants/ecoli-k-12 --pct 80 /working/parchman/Tcristinae_2022/T5_S1_L001_R1_001.fastq > T5_PC.readstofilter.ecoli.txt

echo "ecoli filtering done for lane 1"


cat /working/parchman/Tcristinae_2022/T5_S1_L001_R1_001.fastq | fqu_cull -r T5_PC.readstofilter.ill.txt T5_PC.readstofilter.phix.txt T5_PC.readstofilter.ecoli.txt > T5_PC.clean.fastq

echo "Clean copy of lane 1 done"


