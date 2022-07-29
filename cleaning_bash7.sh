#!/bin/bash

##########################################################################################
## T7 cleaning (Timema Eco Evo, 7.22.22)
##########################################################################################

/working/jahner/tapioca/src/tap_contam_analysis --db  /archive/parchman_lab/rawdata_to_backup/contaminants/illumina_oligos --pct 20 /working/parchman/Tcristinae_2022/T7/T7_S2_L002_R1_001.fastq > T7.readstofilter.ill.txt 

echo "Illumina filtering done for lane 1"

/working/jahner/tapioca/src/tap_contam_analysis --db /archive/parchman_lab/rawdata_to_backup/contaminants/phix174 --pct 80 /working/parchman/Tcristinae_2022/T7/T7_S2_L002_R1_001.fastq > T7.readstofilter.phix.txt 

echo "PhiX filtering done for lane 1"

/working/jahner/tapioca/src/tap_contam_analysis --db  /archive/parchman_lab/rawdata_to_backup/contaminants/ecoli-k-12 --pct 80 /working/parchman/Tcristinae_2022/T7/T7_S2_L002_R1_001.fastq > T7.readstofilter.ecoli.txt

echo "ecoli filtering done for lane 1"

cat /working/parchman/Tcristinae_2022/T7/T7_S2_L002_R1_001.fastq | fqu_cull -r T7.readstofilter.ill.txt T7.readstofilter.phix.txt T7.readstofilter.ecoli.txt > T7.clean.fastq

echo "Clean copy of lane 1 done"


