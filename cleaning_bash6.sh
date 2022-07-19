#!/bin/bash

##########################################################################################
## T6 cleaning (Timema Eco Evo, 7.22.22)
##########################################################################################

/working/jahner/tapioca/src/tap_contam_analysis --db  /archive/parchman_lab/rawdata_to_backup/contaminants/illumina_oligos --pct 20 /working/parchman/Tcristinae_2022/T6/T6_S1_L001_R1_001.fastq > T6.readstofilter.ill.txt 

echo "Illumina filtering done for lane 1"

/working/jahner/tapioca/src/tap_contam_analysis --db /archive/parchman_lab/rawdata_to_backup/contaminants/phix174 --pct 80 /working/parchman/Tcristinae_2022/T6/T6_S1_L001_R1_001.fastq > T6.readstofilter.phix.txt 

echo "PhiX filtering done for lane 1"

/working/jahner/tapioca/src/tap_contam_analysis --db  /archive/parchman_lab/rawdata_to_backup/contaminants/ecoli-k-12 --pct 80 /working/parchman/Tcristinae_2022/T6/T6_S1_L001_R1_001.fastq > T6.readstofilter.ecoli.txt

echo "ecoli filtering done for lane 1"

cat /working/parchman/Tcristinae_2022/T6/T6_S1_L001_R1_001.fastq | fqu_cull -r T6.readstofilter.ill.txt T6.readstofilter.phix.txt T6.readstofilter.ecoli.txt > T6.clean.fastq

echo "Clean copy of lane 1 done"


