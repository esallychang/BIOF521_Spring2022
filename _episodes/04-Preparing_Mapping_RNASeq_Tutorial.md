---
title: "Hands On: Quality Control and Mapping of RNA-Seq Data" 
exercises: 30
objectives:
- "Make use of Galaxy Collections for a tidy analysis"
- "Generate interactive reports to summarise QC information from a collection of files with MultiQC"
- "Use a splice-aware aligner to map RNAseq data to a reference"
keypoints:
- "PLEASE EDIT ME"
---

## Introduction

Measuring gene expression on a genome-wide scale has become common practice over the last two decades or so, with microarrays predominantly used pre-2008. With the advent of next generation sequencing technology in 2008, an increasing number of scientists use this technology to measure and understand changes in gene expression in often complex systems. As sequencing costs have decreased, using RNA-Seq to simultaneously measure the expression of tens of thousands of genes for multiple samples has never been easier. The cost of these experiments has now moved from generating the data to storing and analysing it.

This week, we are going to go through a typical RNAseq pipeline from raw FASTQ file, to counts of reads mapped to genes, to a list of differentially expressed genes and some basic visualizations. Next week, we will build on these results, starting with the read counts, and harness the power of the R programming language to do more complex downstream analyses. 

## Background about the data set 

**Mouse mammary gland dataset**

The data for this tutorial comes from a Nature Cell Biology paper by [Fu et al. 2015](https://www.nature.com/articles/ncb3117). Both the raw data (sequence reads) and processed data (counts) can be downloaded from Gene Expression Omnibus database (GEO) under accession number [GSE60450](http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE60450).

This study examined the expression profiles of basal and luminal cells in the mammary gland of virgin, pregnant and lactating mice. Six groups are present, with one for each combination of cell type and mouse status. Note that two biological replicates are used here, two independent sorts of cells from the mammary glands of virgin, pregnant or lactating mice, however three replicates is usually recommended as a minimum requirement for RNA-seq.

<img src="{{ page.root }}/fig/mouse_exp.png" alt="Fu et al. 2015 RNAseq sampling scheme">

For this hands-on tutorial, we are going to focus on the **basal cell** samples, specifically the **pregnant vs. lactating** comparison. 

> ## Heads up: Results may vary!
> It is possible that your results may be **slightly** different from the ones presented in this tutorial due to differing versions of tools, reference data, external databases, or because of stochastic processes in the algorithms.
> 
{: .callout}

## Data Upload 

All of the data for this experiment can be found under [BioProject PRJNA258286](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA258286), which contains [twelve SRA Experiments](https://www.ncbi.nlm.nih.gov/sra?linkname=bioproject_sra_all&from_uid=258286). For this section of the exercise, use your knowledge of the NCBI SRA and Galaxy uploading options to load the four relevant basal cell sample FASTQs into our Galaxy history. 

> ## Which SRAs contain the samples we are interested in? 
> 1. You can start by downloading [SraRunTable_Fu2015.txt](../data/SraRunTable_Fu2015.txt) file containing metadata for the 12 samples, like we did for the Covid-19 data set last week. 
> 2. Next, open the file in Excel or similar and look at the `Immunophenotype` - six of them should say `basal cell population`. 
> 3. Look at the `Developmental Stage` column. The SRA Run Numbers associated with those samples and their `Developmental_Stage` are: 
> 
> ~~~
> SRR1552452 basalpregnant
> SRR1552453 basalpregnant
> SRR1552454 basallactating
> SRR1552455 basallactating
> ~~~
> 
> So for our comparison of the basal cells of pregnant vs. lactating mice, we will want to look at SRAs `SRR1552452 - SRR1552455`. 
> {: .output}
{: .solution} 

> ## Hands-On Challenge: Load the basal cell data onto Galaxy
> 1. Like last week, we can start by uploading the [SraRunTable_Fu2015.txt](../data/SraRunTable_Fu2015.txt) onto Galaxy using the `Upload Data` tool: <img src="{{ page.root }}/fig/Galaxy_upload_button.png" alt="Galaxy upload button">. 
> 2. Use the <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> Select lines that match an expression  </button> tool to select the relevant lines using the correct **Pattern**. You can either use the same `SRA|SRA` format to search for multiple SRA accession ID numbers as in last week's exercise, OR try to search using a combination of values in the `Developmental_Stage` and `immunophenotype` columns.
> 
> 3. Use the <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> Cut columns from a table (cut) </button> tool just to select the SRA ID column. 
> 4. Use the <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> Faster Download and Extract Reads in FASTQ </button> with the `List of SRA accession, one per line` option.
> 5. You should end up with four files inside your single-ended output of <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> Faster Download and Extract Reads in FASTQ </button>. It will look roughly like below: 
> 
> <img src="{{ page.root }}/fig/Single_End_BasalCell.png" width="400" alt="Single End Input in Galaxy History">
> 
{: .challenge}



## Quality Control of Raw Reads

Next, run the <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> FASTQC </button> tool on the collection you just created. Then, to keep the results from all six samples organized, we will make use of an excellent tool called <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> MultiQC </button> to aggregate them all into one report.

> ## Hands-On: FastQC + MultiQC 
> 1. <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> FASTQC </button> with the following parameters: 
> 	* **Short Read Data from your current history**: `Input Data`.
> 2. <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> MultiQC </button> with the following parameters: 
> 	* **Which tool was used to generate logs?**: `FastQC`. 
> 	* **Type of FASTQC output?** `Raw data`. 
> 	* **FastQC output**: `RawData` files (output of FASTQC on trimmed reads).
> 3. Add a tag `#fastqc-raw` to the `Webpage` output from MultiQC and inspect the webpage. 
{: .challenge} 

> ## Did any of the samples fail any of the their QC checks?
> MultiQC helps us answer this question super quickly with one the final summary plot it produces: 
> 
> <img src="{{ page.root }}/fig/MultiQC_CheckSummary.png" width="400" alt="MultiQC FastQC Checks Summary">
> 
> We can see that all four of our samples failed the `Sequence Duplication` and `Per Base Sequence Composition` checks
> 
> This seems concerning, but not unexpected for RNAseq data, since, as we will see, there are some genes that are very highly expressed (and therefore present in those copies in our sequencing data). We will learn how to deal with widely varying expression levels during later steps of this tutorial.
{: .solution} 

Much like in the first week of class, we will use Cutadapt to trim the reads to remove the Illumina adapter and any low quality bases at the ends (quality score < 20). We will discard any sequences that are too short (< 20bp) after trimming. The Cutadapt tool Help section provides the sequence we can use to trim this standard Illumina adapter `AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC`, as given on the [Cutadapt website](https://cutadapt.readthedocs.io/en/stable/guide.html#illumina-truseq). For trimming paired-end data see the Cutadapt Help section. Other Illumina adapter sequences (e.g. Nextera) can be found at the [Illumina website](http://sapac.support.illumina.com/bulletins/2016/12/what-sequences-do-i-use-for-adapter-trimming.html). Note that Cutadapt requires at least three bases to match between adapter and read to reduce the number of falsely trimmed bases, which can be changed in the Cutadapt options if desired.

> ## Hands-On: Trimming with CutAdapt
> Run <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> CutAdapt </button> with the following parameters: 
> + *"Single-end or Paired-end reads?"*: `Single-end`.
> + *"FASTQ/A file"*: `Input Data` (Input dataset collection).
> + In *"Read 1 Options"*:
> 	- In *"3' (End) Adapters"*:
> 	- Click on *"Insert 3' (End) Adapters"*:
> 	- In *"1: 3' (End) Adapters"*:
> 		- *"Source"*: `Enter custom sequence`. 
> 		- *"Enter custom 3' adapter name (Optional)"*: `Illumina`. 
> 		- *"Enter custom 3' adapter sequence"*: `AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC`. 
> + In *"Filter Options"*:
> 	- *"Minimum length"*: `20`. 
> + In *"Read Modification Options"*:
> 	- *"Quality cutoff"*: `20`. 
> + In *"Output Options"*:
> 	- *"Report"*: `Yes`. 
{: .challenge} 

> ## What percentage of the reads from the `BasalLac_1` sample were retained?
> Looking at the CutAdapt report for the relevant sample, we can see the result line: 
> ~~~
> Total written (filtered):  2,678,580,453 bp (98.4%)
> ~~~
> {: .output}
> After trimming, very few reads were filtered for being too short or too low quality.
{: .solution}

If you would like, you can run the <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> FASTQC </button> and <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> MultiQC </button> again now to confirm that the adaptors have been removed and that the reads are trimmed (check the sequence length distribution - the reads should no longer all be the same length!). Otherwise, we are ready to move on to the next step - mapping these trimmed reads to a reference genome and then counting up the number of reads per gene. 

## Mapping reads to the mouse reference genome

Now that we have prepared our reads, we can align the reads for our 12 samples. There is an existing reference genome for mouse and we will map the reads to that. The current most widely used version of the mouse reference genome is `mm10/GRCm38` (although note that there is a new version `mm39` released June 2020). Here we will use [**HISAT2**](https://ccb.jhu.edu/software/hisat2/index.shtml) to align the reads. HISAT2 is the descendent of TopHat, one of the first widely-used aligners, but alternative mappers could be used, such as STAR. See the [RNA-seq ref-based tutorial]({{ site.baseurl }}/topics/transcriptomics/tutorials/ref-based/tutorial.html#mapping) for more information on RNA-seq mappers. There are often numerous mapping parameters that we can specify, but usually the default mapping parameters are fine. 


However, library type (paired-end vs single-end) and library strandness (stranded vs unstranded) require some different settings when mapping and counting, so they are two important pieces of information to know about samples. The mouse data comprises unstranded, single-end reads so we will specify that where necessary. HISAT2 can output a mapping summary file that tells what proportion of reads mapped to the reference genome. Summary files for multiple samples can be summarised with MultiQC.

**Splice-Aware Mapping** 

With eukaryotic transcriptomes most reads originate from processed mRNAs lacking introns:

<img src="{{ page.root }}/fig/rna-seq-reads.png" alt="Diagram of eukaryotic transcripts">

**Figure Legend**: The types of RNA-seq reads (adaption of the Figure 1a from Kim et al. 2015): reads that mapped entirely within an exon (in red), reads spanning over 2 exons (in blue), read spanning over more than 2 exons (in purple).

Therefore they cannot be simply mapped back to the genome as we normally do for DNA data. Spliced-awared mappers have been developed to efficiently map transcript-derived reads against a reference genome:

<img src="{{ page.root }}/fig/splice_aware_alignment.png" alt="Splice aware alignment">

**Figure Legened**: Principle of spliced mappers: (1) identification of the reads spanning a single exon, (2) identification of the splicing junctions on the unmapped reads. 

> ## Hands-On: Map reads to reference using **HISAT2** 
> 1. Run <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> HISAT2 </button> with the following parameters: 
> + *"Source for the reference genome"*: `Use a built-in genome`. 
> 	- *"Select a reference genome"*: `mm10`. 
> + *"Is this a single or paired library?"*: `Single-end`. 
>	- *"FASTA/Q file"*: `Read 1 Output Collection` (output of **CutAdapt**). 
> + In *"Summary Options"*:
> 	- *"Output alignment summary in a more machine-friendly style."*: `Yes`. 
> 	- *"Print alignment summary to a file."*: `Yes`. 
> 2. Run <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> MultiQC </button> with the following parameters to aggregate the HISAT2 summary files: 
> + In *"Results"*: 
> 	- *"Which tool was used generate logs?"*: `HISAT2`. 
> 	- *"Output of HISAT2"*: `Mapping summary` (output of **HISAT2**). 
> 3. Add a tag `#hisat` to the `Webpage` output from MultiQC and inspect the webpage.
> 
> > ## What file type will the mapping results be?
> > A **BAM** (Binary Sequence Alignment Matrix)! 
> > We have told **HISAT2** to `Output alignment summary in a more machine-friendly style`, as opposed to a human-friendly alignment summary, which would be a SAM file. Look at last week's material if need a refresher on mapping outputs.
> > {: .solution}
>
{: .challenge} 

 
> ## Note: Mapping for Paired-end or stranded reads
> - If you have **paired-end** reads
>     - Select *"Is this a single or paired library"* `Paired-end` or `Paired-end Dataset Collection` or `Paired-end data from single interleaved dataset`
> - If you have **stranded** reads
>     - Select *"Specify strand information"*: `Forward (FR)` or `Reverse (RF)`
{: .callout}

