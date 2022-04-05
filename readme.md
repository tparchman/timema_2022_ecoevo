## 2021/2022 *T. cristinae* GBS workflow 

To expedite and streamline current and future Timema DNA extractions, we worked with AGBIO to develop a method for rapid insect DNA extraction. We performed these extractions in September of 2021. Quality and quantity looked decent, but yields were lower than we generally get with the Qiagen DNeasy kits. 

We made 3 GBS libraries in December 2021 that covered 1800 *T. cristinae* samples, and included a small number of Pinus rigida in each. In order to make sure that the AGBIO DNA extractions performed consistently, we ran one of these libraries (T5_PC) on two lanes of NovaSeq S1 chemistry, which produces an amount of data similar to one lane on the NovaSeq with S2.

Raw data is stored on ponderosa at:
`/archive/parchman_lab/rawdata_to_backup/T5_PC`

### This file contains code and notes for
1) cleaning contaminants using tapioca
2) parsing barcodes
3) splitting fastqs 
4) 
6) 
7) 

## Notes on contaminant cleaning and barcode parsing 2/22

`NOTE`: 2 S1 lanes on GSAF NovaSeq during 2/22/ 
`NOTE`: Contaminant cleaning and barcode parsing in `/working/parchman/Tcristinae_2022`. Working first just with the first lane `T5_S1_L001_R1_001.fastq` in order to evaluate consistency of coverage across samples.

## Cleaning contaminants

Being executed on ponderosa using tapioca pipeline. Commands in bash script, executed as below (2/26/22).

    $ module load fqutils/0.4.1
    $ module load bowtie2/2.2.5
    $ bash cleaning_bash.sh &

After GOAG.clean.fastq has been produced, clean out duplicate raw data:

    $ rm -rf GOAG-lib10_S1_L001_R1_001.fastq
 
Number of reads **before** cleaning:

    $ grep -c "^@" T5_S1_L001_R1_001.fastq > number_of_rawreads.txt &
    $ less number_of_rawreads.txt
    # 
Number of reads **after** cleaning:

    $ grep -c "^@" T5_PC.clean.fastq > number_of_cleanreads.txt &
    $ less number_of_cleanreads.txt
    # 

`NOTE`: All looked well with `T5_S1_L001_R1_001.fastq`, below processing cleaning step for `T5_S1_L002_R1_001.fastq`.

Being executed on ponderosa using tapioca pipeline. Commands in bash script, executed as below (4/2/22).

    $ module load fqutils/0.4.1
    $ module load bowtie2/2.2.5
    $ bash cleaning_bash.sh &

After GOAG.clean.fastq has been produced, clean out duplicate raw data:

    $ rm -rf T5_S1_L002_R1_001.fastq
 
Number of reads **before** cleaning:

    $ grep -c "^@" T5_S1_L002_R1_001.fastq > number_of_rawreadsB.txt &
    $ less number_of_rawreadsB.txt
    # 
Number of reads **after** cleaning:

    $ grep -c "^@" B_T5_PC.clean.fastq > number_of_cleanreadsB.txt &
    $ less number_of_cleanreadsB.txt
    # 




## Barcode parsing:

Barcode keyfile is `/working/parchman/Tcristinae_2022/barcodeKey_lib11_timema5_pineC.csv`

2 lanes need to be parsed:
`T5_PC.clean.fastq` and  `B_T5_PC.clean.fastq`

    $ perl parse_barcodes768.pl barcodeKey_lib11_timema5_pineC.csv T5_PC.clean.fastq A00 &

    $ perl parse_barcodes768.pl barcodeKey_lib11_timema5_pineC.csv B_T5_PC.clean.fastq A00 &


# DONE TO HERE


`NOTE`: the A00 object is the code that identifies the sequencer (first three characters after the @ in the fastq identifier).

    $ less parsereport_GOAG.clean.fastq
    Good mids count: 


Cleaning up the directory:

    $ rm GOAG.clean.fastq
    $ rm miderrors_GOAG.clean.fastq
    $ rm parsereport_GOAG.clean.fastq


## Splitting fastq by individual ID

Make ids file

    $ cut -f 3 -d "," barcodeKey_CLEAN_desertTortoises.csv | grep "_" > GOAG_ids_noheader.txt
    # Note: 698 individuals


Split fastqs by individual, put in a new directory

    $ mkdir raw_fastqs
    $ perl splitFastq_universal_regex.pl GOAG_ids_noheader.txt parsed_GOAG.clean.fastq &

Zip the parsed*fastq files for now, but delete once patterns and qc are verified:

    $ gzip GOAG.clean.fastq

# Done to here 11/16/21

Total reads for GOAG (698 individuals)

    $ grep -c "^@" raw_fastqs/*fastq > seqs_per_ind.txt

Summarize in R

    R
    dat <- read.delim("seqs_per_ind.txt", header=F, sep=":")
        dim(dat)
        head(dat)
        
    sum(dat[,2])
        

Zip fastqs:

    $ gzip raw_fastqs/*fastq
