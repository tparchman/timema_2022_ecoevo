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

Afte clean.fastq has been produced, clean out duplicate raw data:

 
Number of reads **before** cleaning:

    $ grep -c "^@" T5_S1_L001_R1_001.fastq > number_of_rawreads.txt &
    $ less number_of_rawreads.txt
    # 
Number of reads **after** cleaning:

    $ grep -c "^@" T5_PC.clean.fastq > number_of_cleanreads.txt &
    $ less number_of_cleanreads.txt
    # 

### DNAs were sequenced on three libraries. Two of those had only timema (T6 and T7), one also had pinus rigida (T5). 

### First, processed T5, cleaning steps for `T5_S1_L002_R1_001.fastq`:

Being executed on ponderosa using tapioca pipeline. Commands in bash script, executed as below (4/2/22).

    $ module load fqutils/0.4.1
    $ module load bowtie2/2.2.5
    $ bash cleaning_bash.sh &

After clean.fastq has been produced, clean out duplicate raw data:

    $ rm -rf T5_S1_L002_R1_001.fastq
 
Number of reads **before** cleaning:

    $ grep -c "^@" T5_S1_L002_R1_001.fastq > number_of_rawreadsB.txt &
    $ less number_of_rawreadsB.txt
    # 
Number of reads **after** cleaning:

    $ grep -c "^@" B_T5_PC.clean.fastq > number_of_cleanreadsB.txt &
    $ less number_of_cleanreadsB.txt
    # 

### Second, cleaning steps for T6 and T7 `T6_S1_L001_R1_001.fastq.gz`,`T6_S1_L001_R1_001.fastq.gz`, stored at: 

/archive/parchman_lab/rawdata_to_backup/timema_EcoEvoGBS_7_13_22/

Being executed on ponderosa using tapioca pipeline. Commands in bash script, executed as below (7/18/22).

For T6 (`/working/parchman/Tcristinae_2022/T6`):

    $ module load fqutils/0.4.1
    $ module load bowtie2/2.2.5
    $ bash cleaning_bash6.sh &

And for T7(`/working/parchman/Tcristinae_2022/T7`):

    $ module load fqutils/0.4.1
    $ module load bowtie2/2.2.5
    $ bash cleaning_bash7.sh &

After clean.fastq has been produced, clean out duplicate raw data:

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

For T5:
2 lanes need to be parsed:
`T5_PC.clean.fastq` and  `B_T5_PC.clean.fastq`

    $ perl parse_barcodes768.pl barcodeKey_lib11_timema5_pineC.csv T5_PC.clean.fastq A00 &

    $ perl parse_barcodes768.pl barcodeKey_lib11_timema5_pineC.csv B_T5_PC.clean.fastq A00 &



`NOTE`: the A00 object is the code that identifies the sequencer (first three characters after the @ in the fastq identifier).

    $ less parsereport_B_T5_PC.clean.fastq
    #Good mids count: 520687693
    #Bad mids count: 37522471
    #Number of seqs with potential MSE adapter in seq: 200352
    #Seqs that were too short after removing MSE and beyond: 354

    $ less parsereport_T5_PC.clean.fastq
    #Good mids count: 521146575
    #Bad mids count: 38505020
    #Number of seqs with potential MSE adapter in seq: 193168
    #Seqs that were too short after removing MSE and beyond: 317


Each fastq file has data for the same set of individuals. Combining those two files here with `cat` to make one file with all data:

    $ cat parsed_B_T5_PC.clean.fastq parsed_T5_PC.clean.fastq > parsed_Tc3_pineC.fastq &


Cleaning up the directory:

    $ rm T5_PC.clean.fastq
    $ rm miderrors_T5_PC.clean.fastq
    $ rm parsereport_T5_PC.clean.fastq

    $ rm B_T5_PC.clean.fastq
    $ rm miderrors_B_T5_PC.clean.fastq
    $ rm parsereport_B_T5_PC.clean.fastq

### For T6 and T7
2 lanes need to be parsed:
`T6.clean.fastq` and  `T7.clean.fastq`

    $ nohup perl parse_barcodes768.pl bc_key_library12_timema6_final.csv T6.clean.fastq A00 &>/dev/null &

    $ less parsereport_T6.clean.fastq
    Good mids count: 1311531766
    Bad mids count: 220007814
    ## note bad mids count is a bit high.

    $ nohup perl parse_barcodes768.pl library13_timema7_pineB.csv T7.clean.fastq A00 &>/dev/null &


**Splitting big fastqs into smaller files to speed up parsing**

T7.clean.fastq has 5961989268 lines. Dividing by 11, making smaller files with 541999024 lines each (this is cleanly divided by 4):

    $ split -l 541999024 T7.clean.fastq

### running parsing for 11 smaller files:

    $ nohup perl parse_barcodes768.pl library13_timema7_pineB.csv xaa A00 &>/dev/null &

    $ nohup perl parse_barcodes768.pl library13_timema7_pineB.csv xab A00 &>/dev/null &

    $ nohup perl parse_barcodes768.pl library13_timema7_pineB.csv xac A00 &>/dev/null &

    $ nohup perl parse_barcodes768.pl library13_timema7_pineB.csv xad A00 &>/dev/null &

    $ nohup perl parse_barcodes768.pl library13_timema7_pineB.csv xae A00 &>/dev/null &

    $ nohup perl parse_barcodes768.pl library13_timema7_pineB.csv xaf A00 &>/dev/null &


    $ nohup perl parse_barcodes768.pl library13_timema7_pineB.csv xag A00 &>/dev/null &

    $ nohup perl parse_barcodes768.pl library13_timema7_pineB.csv xah A00 &>/dev/null &

    $ nohup perl parse_barcodes768.pl library13_timema7_pineB.csv xai A00 &>/dev/null &

    $ nohup perl parse_barcodes768.pl library13_timema7_pineB.csv xaj A00 &>/dev/null &

    $ nohup perl parse_barcodes768.pl library13_timema7_pineB.csv xak A00 &>/dev/null &

    $ nohup perl parse_barcodes768.pl library13_timema7_pineB.csv xal A00 &>/dev/null &


### catting together into one file:

    $ nohup cat parsed_xa* > parsed_T7.clean.fastq &>/dev/null &

    $ less parsereport_T7.clean.fastq
    Good mids count: 1381529754
    Bad mids count: 108966022
    ## note bad mids count is a bit high.

`NOTE`: the A00 object is the code that identifies the sequencer (first three characters after the @ in the fastq identifier).

    $ less parsereport_B_T5_PC.clean.fastq
    #Good mids count: 520687693
    #Bad mids count: 37522471
    #Number of seqs with potential MSE adapter in seq: 200352
    #Seqs that were too short after removing MSE and beyond: 354

    $ less parsereport_T5_PC.clean.fastq
    #Good mids count: 521146575
    #Bad mids count: 38505020
    #Number of seqs with potential MSE adapter in seq: 193168
    #Seqs that were too short after removing MSE and beyond: 317


## Splitting fastq by individual ID

### Make ids files for T5, T6, and T7

**T5**

    $ cut -f 3 -d "," barcodeKey_lib11_timema5_pineC.csv | grep "_" > T3_pineC_ids_noheader.txt

    # Note: 546 individuals

**T6**

    $ cut -f 3 -d "," bc_key_library12_timema6_final.csv | grep "_" > T6_noheader.txt

    # Note: 672 individuals

**T7**

    $ cut -f 3 -d "," library13_timema7_pineB.csv | grep "_" > T7_ids_noheader.txt

    # Note: 672 individuals, including some pinus individuals that have been removed.

## Split fastqs by individual, put in a new directory

**T5**

    $ mkdir splitfastqs
    $ nohup perl splitFastq_universal_regex.pl T3_pineC_ids_noheader.txt parsed_Tc3_pineC.fastq &>/dev/null &

**T6**

    $ mkdir splitfastqs
    $ nohup perl splitFastq_universal_regex.pl T6_noheader.txt parsed_T6.clean.fastq &>/dev/null &

**T7**

    $ mkdir splitfastqs
    $ nohup perl splitFastq_universal_regex.pl T7_ids_noheader.txt parsed_T7.clean.fastq &>/dev/null &
    
Delete clean.fastq files:

    $ rm -rf *.clean.fastq

Delete parsed*fastq files:

    $ rm -rf parsed_*.fastq
        

Zip fastqs:

    $ nohup gzip raw_fastqs/*fastq &>/dev/null &
