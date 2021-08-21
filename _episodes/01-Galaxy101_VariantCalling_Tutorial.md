---
title: "Week 1 - Variant Calling in Galaxy (Tutorial)"
teaching: 90
exercises: 90
questions:
- "How can we best analyze our data?"
objectives:
- "Manage a Galaxy history in order to keep data organized for an analysis"
- "Load data from the NCBI SRA into the environment"
- "Identify major steps in a variant-calling workflow and their associated file types"
keypoints:
- "Galaxy is an open source tool for conducting bioinformatic analyses"
- "FASTQ files generally store raw sequencing data"
---

## This week's data set

We are going to be 

## Steps in Variant Calling

As you learned from this week's lectures, variant-calling is the process of identifying small variations in the sequence data of one sample compared to another, generally a standard reference that we can compare to multiple samples. We are now going to be doing some variant-calling ourselves to answer the questions posed in the section above.

*   Obtaining sequence data.
  + Identifying samples of interest from their metadata
  + Using the Galaxy interface to load the sequence data from these samples into your workspace
*   Pre-processing the data. 
  + Run FASTQC to diagnose any major issues
*   motivating questions
*   lesson objectives
*   a summary of key points

## Prerequisites
This tutorial assumes that you have done the following:
* Signed up for a Galaxy account and can log in 
* Have taken a look at the Galaxy Environment 101 Tutorial

## Obtaining data from the NCBI Short Read Archive

First we need to identify some samples of interest. The Sequence Read Archive (SRA) is the primary archive of unassembled reads operated by the US National Institutes of Health (NIH). SRA is a great place to get the sequencing data that underlie publications and studies. We know where to find the data because Science (and in fact, most publications) require authors to deposit their data in a public database and give us the information we need to find it on the database. 

The data availability statement can be found in the acknowledgements section of Lemieux et al. 2020: 

<a href="{{ page.root }}/fig/Lemieux_Data_Statement.png">
  <img src="{{ page.root }}/fig/Lemieux_Data_Statement.png" alt="Data availability statement from Lemieux et al. 2020" />
</a>

As you can see, we now know we can find sequencing data related to this study under `BioProject PRJNA622387`. As defined by the NCBI, a BioProject is "a collection of biological data related to a single initiative, originating from a single organization or from a consortium", so they generally contain multiple sequencing data sets. The NCBI has much a much more [in-depth description of BioProjects][bioproject] on its webpage. 

If you click on the first 

> ## "Hands-On: Get Metadata from NCBI SRA"
> 1. Go to NCBI’s SRA page by pointing your browser to `https://www.ncbi.nlm.nih.gov/sra`
> 2. Perform a search using the Bioproject ID from above: `BioProject PRJNA622387`
> <img src="{{ page.root }}/fig/SRA_Bioproject_Search.png" alt="SRA search toolbar filled in with Bioproject ID from above">
> 3. The web page will show a large number of available SRA datasets related to project described in Lemieux et al. 2020 (at the time of writing there were 3,927). 
> 4. Download metadata describing these datasets by:
>   * clicking on **Send to**: dropdown
>   * Selecting `File`
>   * Changing **Format** to `RunInfo`
>   * Clicking **Create file**. The screen should now look like this: 
> <img src="{{ page.root }}/fig/SRA_Download_RunInfo_Menu.png" alt="SRA Download RunInfo Menu Options">
> 5. Click "Create File" to download the `SraRunInfo.csv` file to a place on your computer where you will be able to find it easily for the next step.
{: .challenge}


## Process and filter `SraRunInfo.csv` file in Galaxy

So, what is in the the SRA Run Info file?

The file we just downloaded is **not** sequencing data itself. Rather, it is **metadata** describing the properties of sequencing reads. We could actually open this file in a program like Excel, and if we did so, we could see columns of information like **Release Date**, **Sequencing Platform**, and **Sample Name** as reported by the researchers. In this study every accession corresponds to an individual patient whose samples were sequenced. We will filter this list down to just a few sequenced samples that will be used in the remainder of this tutorial. 

This is all very valuable information - for example, we can use the **Sample Name** to retrieve information about when the sample was actually collected: 

You can search for a **Sample Name** in the general NCBI database by using the **All Databases** option in the toolbar: 

<img src="{{ page.root }}/fig/NCBI_Sample_SearchBar.png" alt="Searching NCBI By Sample Name">

We can see that the sample that was sequenced to become the SRA sequencing dataset `SRS8612691` was collected on January 4th, 2021 and was collected as part of routine surveillance: 

<img src="{{ page.root }}/fig/NCBI_SampleSearch_Results.png" alt="Results of Searching NCBI By A Sample Name">

> ## Hands-On: Upload `SRARunInfo.csv` onto Galaxy
> 1. If you haven't already, log in to your Galaxy account. Create a new, empty history called something like "Variant Calling Tutorial".
> 2. In the tools panel, click the **Upload Data** button: 
>
> <img src="{{ page.root }}/fig/Galaxy_upload_button.png" alt="Galaxy upload button">
> 
> 3. Find `SRARunInfo.csv` on your computer, and drag it into the "Drop Files Here" space in the dialog box that pops up.
> 4. Click the **Start** button to begin the upload. 
> 5. At this point, you can press the **Close** button. In a several seconds, `SRARunInfo.csv` should be ready to look at in the History panel. 
> 6. You can now look at the content of this file by clicking on the eye icon <span class="glyphicon glyphicon-eye-open"></span>. You will see that this file contains a lot of information about individual SRA accessions.
> 
> How large is the sequencing file associated with the accession number `SRR14114810`? 
> 
> > ## Solution
> >
> > 272 MB. If you open the file by clicking the eye icon, you should be able to find `SRR14114810` in the **Run** column, and then look over to see 272 in the **size_MB** column. 
> >
> {: .solution}
> **Note:** If you ever want a smaller summary of the data, you can also click the Pencil icon <span class="glyphicon glyphicon-pencil"></span>, which should produce something like this: 
> 
> <img src="{{ page.root }}/fig/Galaxy_Pencil_Summary.png" alt="Data summary produced by clicking Pencil icon in Galaxy History">
{: .challenge}



The Galaxy servers are powerful enough to process all 2,000+ datasets, but to make this tutorial bearable we need to selected a smaller, but still interesting, subset. In particular, we are interested in samples from early in the ongoing Covid-19 pandemic, so we will be choosing samples collected in April and May of 2020, which I have chosen using the "Collection Date" information retrieved by as described above. 

**We are going to focus on the following two sequencing data sets:** 
* Run Number `SRR12733957`: A sequencing run from a sample collected on April 6th, 2020.
* Run Number `SRR11954102`: A sequencing run from a sample collected on May 2nd, 2020.

> ## Hands-On: Creating a subset of data
>
> 1. Find the <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> Select lines that match an expression  </button> tool in the **Filter and Sort** section of the tool panel. You may find that Galaxy has an overwhelming amount of tools installed. To find a specific tool type the tool name in the tool panel search box to find the tool.
> 
> 2. Make sure the SraRunInfo.csv dataset we just uploaded is listed in the <span class="glyphicon glyphicon-file"></span> **Select lines from** field of the tool form.
>
> 3. In the **Pattern** field enter the following expression: `SRR12733957|SRR11954102`. The "&#124;" symbol (called a "pipe") means "or". So we are telling this tool to find lines containing `SRR12733957` OR `SRR11954102`.
> 4. Click the `Execute` button.
> 5. Once the this has been executed, you should have a file with a total of three lines. If you look at the file (<span class="glyphicon glyphicon-eye-open"></span>), you will see that one of the two lines has been duplicated to take the place of the "header" line (which is fine for now). 
> 6. Cut the first column from the file using the <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> Cut columns from a table (cut) </button>  tool, which you will find in **Text Manipulation** section of the tool pane. 
> <span class="glyphicon glyphicon-warning-sign"></span> WARNING: There are two cut tools in Galaxy due to historical reasons. For this tutorial we are assuming you are using the one described above. The other tool follows a similar logic but with a different interface. <span class="glyphicon glyphicon-warning-sign"></span> 
> 7. Make sure the dataset produced by the previous step is selected in the **File to cut** field of the tool form.
> 8. Change **Delimited by** to `Comma`.
> 9. In **List of fields** drop-down menu select `Column: 1`. This is telling the tool to only return the first column of our data.
> 10. Hit `Execute`.  This will produce a text file with just two lines:
> ~~~
> SRR12733957
> SRR11954102
> ~~~
> {: .output}
{: .challenge}

## Downloading the actual sequence data

So, now we have a file that contains just the two accession numbers for the sequencing data sets that we want. This is the perfect input for tools in Galaxy that can use this information to download big sequencing data sets straight from the NCBI SRA directly into your Galaxy environment without ever putting the big files on your computer. 

> ## Hands-On: Getting data from SRA
> 1. <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> Faster Download and Extract Reads in FASTQ </button> with the following parameters: 
> - **Select Input Type**: `List of SRA Accession, one per line`. 
> - The input parameter <span class="glyphicon glyphicon-file"></span> **select input type** should point the output of <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> Cut columns from a table (cut) </button>. 
> 2. Click the `Execute` button. This will run the tool, which retrieves the sequence read read datasets and places them into your Galaxy environment. <span class="glyphicon glyphicon-time"></span> Note that this step can take a few minutes, so this might be a good time get get a fresh cup of coffee!
> 3. <span class="glyphicon glyphicon-eye-open"></span> Take a look at the entries that were created in your history panel: 
> - `Pair-end data (fasterq-dump)`: Contains Paired-end datasets (if available)
> - `Single-end data (fasterq-dump)`:  Contains Single-end datasets (if available)
> - `Other data (fasterq-dump)`:  Contains Unpaired datasets (if available)
> - `fasterq-dump log`: Contains Information about the tool execution
>
> Is the data we downloaded **single-end** or **paired-end** data? 
> > ## Solution
> > Our data is **paired-end**! If you click each of the data files generated that are now in your history, you will see that `Single-end data (fasterq-dump)` is an empty list, meaning that the tool did not download any files of that type. On the other hand, `Pair-end data (fasterq-dump)` is a "list of pairs with 2 items", each of which is a FASTQ-formatted file if you look inside: 
> > <img src="{{ page.root }}/fig/List_of_Pairs.png" alt="Preview of paired-end data downloaded by fasterq-dump tool">
> > 
> {: .solution}
{: .challenge}

`Pair-end data (fasterq-dump)`, `Single-end data (fasterq-dump)` and `Other data (fasterq-dump)` are actually collections of datasets. Collections in Galaxy are logical groupings of datasets that reflect the semantic relationships between them in the experiment / analysis. In this case the tool creates separate collections for paired-end reads, single reads, and other (any other type of file). See the [Galaxy Collections tutorial][collections-tutorial] and watch [Galaxy tutorial videos][galaxy-videos] (with names beginning with “Dataset Collections”) for more information.

Explore the collections by first clicking on the collection name in the history panel. This takes you inside the collection and shows you the datasets in it. You can then navigate back to the outer level of your history.

Once `fasterq` finishes transferring data (all boxes are green / done), we are ready to analyze it.

## A quick aside: What is **paired-end** data? 

It is common to prepare pair-end and mate-pair sequencing libraries. This is highly beneficial for a number of applications discussed, such as those discussed in Week 2's **Genome Assembly** module. For now let’s just briefly discuss what these are and how they manifest themselves in FASTQ form.

<img src="{{ page.root }}/fig/pairedend_matepair.png" alt="Diagram of paired-end and mate-pair sequencing data">

In **paired-end** sequencing (left) the actual ends of rather short DNA molecules (less than 1kb) are determined, while for **mate-pair** sequencing (right) the ends of long molecules are joined and prepared in special sequencing libraries. In these mate pair protocols, the ends of long, size-selected molecules are connected with an internal adapter sequence (i.e. linker, yellow) in a circularization reaction. The circular molecule is then processed using restriction enzymes or fragmentation. Fragments are enriched for the linker and outer library adapters are added around the two combined molecule ends. The internal adapter can then be used as a second priming site for an additional sequencing reaction in the same orientation or sequencing can be performed from the second adapter, from the reverse strand. (From “Understanding and improving high-throughput sequencing data production and analysis”, Ph.D. dissertation by Martin Kircher)

**Thus in both cases (paired-end and mate-pair) a single physical piece of DNA (or RNA in the case of RNA-seq) is sequenced from two ends and so generates two reads**. These can be represented as separate files (two FASTQ files with first and second reads) or a single file were reads for each end are interleaved (discussed later). Each of our data sets is a pair of FASTQ files, with each data set having a file for "Forward" read and "Reverse" reads. 

For example, the first two reads of the `SRR11954102` data set are: 

**Forward** 
~~~
@SRR11954102.1 1 length=101
ACGGGGGGGCTTACCATCTGGCCCCAGTGCTGCAATGATACCGCGAGACCCACGCTCACCGGCTCCAGATTTATCAGCAATAAACCAGCCAGCCGGAAGGG
+SRR11954102.1 1 length=101
FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
@SRR11954102.2 2 length=101
GCATTAAGCGCGGCGGGTGTGGTGGTTACGCGCAGCGTGACCGCTACACTTGCCAGCGCCCTAGCGCCCGCTCCTTTCGCTGTCTTCCCTTCCTTTCTCGC
+SRR11954102.2 2 length=101
FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,FFFFFFFFFFFFFFFFFFF
~~~ 
{: .output}

**Reverse** 
~~~
@SRR11954102.1 1 length=101
AACTCGCCTTGATCGTTGGGAACCGGAGCTGAATGAAGCCATACCAAACGACGAGCGTGACACCACGATGCCTGTAGCAATGGCAACAACGTTGCGCAAAC
+SRR11954102.1 1 length=101
FFFFFFF:FFFFFFFFFFFFF:FFFFFFFFFFFFF:FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF:FFFFFFFFF
@SRR11954102.2 2 length=101
CCCTTTAGGGTTCCGATTTAGTGCTTTACGGGGAAAGCCGGCGAACGTGGCGAGAAAGGAAGGGAAGAAAGCGAAAGGAGCGGGCGCTAGGGCGCTGGCAA
+SRR11954102.2 2 length=101
FF:FFFFFFFFFFFFFFFFFF:FFFFFFFFF:FFFF:FFFFFFFFFFF:FFFFFFFFFFFFFFFFFF:FFFFFFFFFFFFFFFFFFFFFF:FFFFFFFFFF
~~~
{: .output}

> ## Read order is important.
> Note that read IDs (i.e. `@SRR11954102.1`) are identical in two files and that they are listed in the same order. In some cases read IDs in the first and second file may be appended with /1 and /2 tags, respectively. 
> Nearly all downstream analyses with these pairs of paired-end files assume that the reads are in the same order in both the Forward and Reverse files, which can be a source of frustration if they accidentally get mixed up!
{: .callout}

## Removing adapters and low-quality reads with **fastp**

Many sequencing technologies, such as the short-read Illumina data we are working with today, require adapter sequences to be added to the pieces of DNA we want to sequence in order to prime the sequencing reaction(s) that will be taking place on those pieces of DNA. For a **paired-end** library that we are working with, there will be an adapter attached to each end of each DNA molecule, like this: 

<img src="{{ page.root }}/fig/read_through_adapter.png" alt="Diagram of what adapter read-through looks like">

In certain circumstances, the adapters themselves will be sequenced. One such situation is if some pieces of the actual DNA to be sequenced are shorter than the chosen read length of the sequencing run. For example, if we were targeting 100bp reads, but some of the DNA was very fragmentary and only 80bp long, these sequences would have about 20bp each of "_adapter read-through_" (pictured in red above). 

In the most extreme case, if the input DNA is very low concentration and/or small, the sequencing adapters (and/or the sequencing primers) will anneal directly to one another instead of any target sequence during preparation of the sequencing library and then get sequenced. These are called "adapter dimers" and "primer dimers", respectively. 

No matter where they come from, removing sequencing adapters from the raw sequencing data improves alignments and variant calling, so we are going to make sure they get removed from our data in this step. 

**Fastp does the following to our data** : 
- Filter out bad reads (too low quality, too short, etc.). The default sequence quality filter for **Fastp** is a Phred score of 30. Check back in your slides to see what base-calling accuracy this corresponds to! 
- Cut low quality bases for per read from their 5' and 3' ends
- Cut adapters. Adapter sequences can be automatically detected, which means you don't have to input the adapter sequences to trim them.
- Correct mismatched base pairs in overlapped regions of paired end reads, if one base is with high quality while the other is with ultra-low quality
- Several other filtering steps specific to different types of sequencing data. 

More information can be found on the Fastp website: `https://github.com/OpenGene/fastp`

> ## Hands-On: Running `fastp`
> 1. Find the <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> fastp - fast all-in-one preprocessing for FASTQ files </button> tool. 
> 2. Set **single or paired reads** to `Paired Collection`. 
> 3. Make sure <span class="glyphicon glyphicon-file"></span> **Select paired collection(s)** set to `list paired`, and make sure that you have selected the output of <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> Faster Download and Extract Reads in FASTQ </button>.
> 4. Under **Output Options**, set **Output JSON report** to `Yes`. This will create a nice, human-readable report about the quality of our input data sets that we will examine below. (MIGHT NEED TO REMOVE). 
> 5. Press `Execute`. 
{: .challenge}

## Examining the **fastp** results

The HTML reports from filtering these data sets are **FULL** of information about the quality of these sequencing data sets. 

For example, what percentage of the reads from `SRR11954102` passed all of the filters of the <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> fastp - fast all-in-one preprocessing for FASTQ files </button> tool and remain in our data set? What about `SRR12733957`?

> ## Solution
> About 90% and 67%, respectively. 
> To figure this out, first click on **fastp on collection: HTML Report**. Then, look into each of the data sets <span class="glyphicon glyphicon-eye-open"></span>, and find the `Filtering Result` result section. 
> For the `SRR12733957` data set, this should roughly look like: 
> ~~~
> Filtering result
> reads passed filters:	592.644000 K (67.755212%)
> reads with low quality:	279.816000 K (31.990525%)
> reads with too many N:	132 (0.015091%)
> reads too short:	2.092000 K (0.239172%)
> ~~~
> {: .output}
> For the `SRR11955102` data set, this should roughly look like: 
> ~~~
> reads passed filters:	2.650592 M (90.679913%)
> reads with low quality:	270.274000 K (9.246396%)
> reads with too many N:	2.154000 K (0.073691%)
> reads too short:	0 (0.000000%)
> ~~~
> {: .output}
{: .solution}

Of the 10% of reads that were filtered from the data set `SRR11955102`, why were most of them filtered? 

> ## Solution 
> It looks like most of the reads that ended up getting removed from either data set were removed were removed because they were too low quality (average Phred score < 32). 
> We can tell this by looking again at the `Filtering Result` section, and seeing that about 9.2% out of the roughly 10% of the reads removed were removed as `Reads with low quality`. 
{: .solution}

What are some of the main things we can learn from this plot of the quality of the **Forward** reads of the `SRR11954102` **BEFORE** they were filtered? 

<img src="{{ page.root }}/fig/SRR11954102_before.png" alt="Fastp graph of pre-filtered read quality along the length of a read for SRR11954102">

> ## Solution
> A few of the things that I noticed are as follows.
> + The reads are about 100bp long (see Position x-axis).
> + The quality of the reads declines along their lengths, similar to the patterns described in the "Read Quality" lecture. 
> + Some bases towards the end of the read are lower than the cutoff quality score (Phred > 32), especially for the any bases called as a G. 
> + What else do you notice? 
{: .solution}

What are some of the main things we can learn from this plot of the quality of the **Forward** reads of the `SRR11954102` **AFTER** they were filtered? 

<img src="{{ page.root }}/fig/SRR11954102_after.png" alt="Fastp graph of post-filtering read quality along the length of a read for SRR11954102">

> ## Solution
> A few of the things that I noticed are: 
> + The reads are still about 100bp long (see Position x-axis).
> + The quality of the reads still declines along their lengths.
> + However, all bases along the length of the read are now over the `Phred > 32` read-quality cutoff. 
> + What else do you notice? 
{: .solution}

## Getting the SARS-CoV-2 Reference Genome

In order to see what mutations the Boston strains of SARS-CoV-2 have accumulated relative to the original strain isolated from patients from Wuhan, China, we are going to map our filtered sequencing data to the full assembled genome of one of the original SARS-CoV-2 isolates, `Wuhan-Hu-1`. It has an accession ID of `NC_045512.2`, which you can search for on NCBI much like we did for the Boston samples to get more information. The `Wuhan-Hu-1` reference genome is stored as a compressed `FASTA` file, which we will discuss in much greater detail in Week 2. 

> ## Hands-On: Importing the reference genome from NCBI
> 1. Click the **Upload Data** button in the toolbar.
> 2. In the menu that pops up, click on **Paste/Fetch Data** 
> 3. Copy and paste this address in the box: `https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/009/858/895/GCF_009858895.2_ASM985889v3/GCF_009858895.2_ASM985889v3_genomic.fna.gz`
> <img src="{{ page.root }}/fig/paste_fetch_data_box.png" alt="Galaxy fetch data window with address in the box">
> 4.Press `Start`. You can close the window now.
{: .challenge}

## Mapping short-reads to the reference genome with **BWA-MEM** 

As you learned in the slides about **Read-Mapping and the SAM/BAM format**, sequencing produces a collection of sequences without genomic context. We do not know to which part of the genome the sequences correspond to. Mapping the reads of an experiment to a reference genome is a key step in modern genomic data analysis. With the mapping the reads are assigned to a specific location in the genome and insights like the expression level of genes can be gained.

Read mapping is the process to align the reads on a reference genomes. A mapper takes as input a reference genome and a set of reads. Its aim is to align each read in the set of reads on the reference genome, allowing mismatches, indels and clipping of some short fragments on the two ends of the reads:

<img src="{{ page.root }}/fig/read_mapping.png" alt="Theoretical diagram of several short reads mapping to a reference genome">

**Figure Legend**: Illustration of the mapping process. The input consists of a set of reads and a reference genome. In the middle, it gives the results of mapping: the locations of the reads on the reference genome. The first read is aligned at position 100 and the alignment has two mismatches. The second read is aligned at position 114. It is a local alignment with clippings on the left and right. The third read is aligned at position 123. It consists of a 2-base insertion and a 1-base deletion.

**Mapping against a pre-computed genome index:** 

Mappers usually compare reads against a reference sequence that has been transformed into a highly accessible data structure called genome index. Such indexes should be generated before mapping begins. Galaxy instances typically store indexes for a number of publicly available genome builds:

<img src="{{ page.root }}/fig/cached_genome.png" alt="Example of selected a pre-indexed version of the human genome available on Galaxy">

For example, the image above shows indexes for hg38 version of the human genome. You can see that there are actually three choices: (1) `hg38`, (2) `hg38 canonical` and (3) `hg38 canonical female`. The `hg38` contains all chromosomes as well as all unplaced contigs. The `hg38 canonical` does not contain unplaced sequences and only consists of chromosomes 1 through 22, X, Y, and mitochondria. The `hg38 canonical` female contains everything from the canonical set with the exception of chromosome Y.

**What if the pre-computed index does not exist?**

If Galaxy does not have a genome you need to map against, you can upload your genome sequence as a FASTA file and use it in the mapper directly as shown below (Load reference genome is set to History). **This is what we will need to do to use the `Wuhan-Hu-1`reference genome we just downloaded.**

> ## Hands-On: Map sequencing reads to reference genome
> **BWA-MEM** is a widely used sequence aligner for short-read sequencing datasets such as those we are analysing in this tutorial.
> 1. Find the <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> Map with BWA-MEM </button> tool in the Tools panel.
> 2. For the **Will you select a reference genome from your history or use a built-in index?** parameter, choose `Use a genome from history and build index`. 
> 3. For the <span class="glyphicon glyphicon-file"></span> **Use the following dataset as the reference sequence** select the output from importing the reference genome in the last hands-on step. 
> 4. For **Single or Paired-End Reads** select `Paired Collection`, and for <span class="glyphicon glyphicon-file"></span> **Select a paired collection** choose the output of <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> fastp - fast all-in-one preprocessing for FASTQ files </button>. Your window should now look something like this: 
> <img src="{{ page.root }}/fig/BWAMEM_Input_Screen.png" alt="Tool parameter screen for BWA MEM tool with inputs and settings">
> 5. **Set read groups information?**: `Do not set`
> 6. **Select analysis mode** : `1. Simple Illumina Mode`. 
> 7. Click `Execute`! 
> <span class="glyphicon glyphicon-time"></span> This may take a few minutes to run. <span class="glyphicon glyphicon-time"></span>. 
{: .challenge}

## Preparing the results of read-mapping for variant-calling

In the next few steps, we will be processing the output from <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> Map with BWA-MEM </button> in order to make the variant calling step go as smoothly as possible: 
  1. Removing duplicates
  2. Re-aligning reads
  3. Adding indel qualities. 

We will be feeding the output of one step right into the next one as input, which is very common for multi-step bioinformatics analyses. 

## Process Mapping Results Step 1: Removing duplicates

As you can probably guess from the name of this step, this removes duplicate sequences originating from library preparation artifacts and sequencing artifacts. It is important to remove this artifactual sequences to avoid artificial sequences to avoid artificial overrepresentation of particular single molecules.

What percentage of reads were duplicated in the raw `SRR11954102`? What about in the original `SRR12733957` data set? **Hint**: This information can be found in output that we already have in our history.

> ## Solution 
> Take a look back at the HTML report generated by the <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> Fastp </button> tool. 
> There is a `Duplication` section available that looks like the following for `SRR11954102`:
> <img src="{{ page.root }}/fig/SRR11954102_Duplication.png" alt="Duplication section of Fastp report for sample SRR11954102">
> We can see form this graph that most sequences are present in only one copy (duplication level of 1), meaning this sample has a low overall duplication level (2.3%) - only 2.3% of sequences are duplicates of each other. 
>
> If we look at `SRR12733957`, we see that this level is much greater (22.8%). 
> <img src="{{ page.root }}/fig/SRR12733957_Duplication.png" alt="Duplication section of Fastp report for sample SRR12733957">
{: .solution}

> ## Measuring duplication levels
> Note that the levels of duplication  are inferred based on read sequence similarity alone because the short-read data had not been mapped to a reference genome yet. The following **Mark Duplicates** step will remove duplicate copies of reads while incorporating information about their mapped position on the reference genome.
{: .callout}

> ## Hands-On: Removing Duplicates
> Find the <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> Mark Duplicates </button> tool. The full title should be something like `Mark Duplicates examine aligned records in BAM datasets to locate duplicate molecules`. 
>
> Run this tool with the following parameters: 
> + **Select SAM/BAM dataset or dataset collection**: Click the folder icon <span class="glyphicon glyphicon-folder-close"></span> and choose output of <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> Map with BWA-MEM </button>. 
> + **If true do not write duplicates to the output file instead of writing them with appropriate flags set** set to `Yes`. This switch tells **Mark Duplicates** to not only mark which short reads are duplicates of one another, but to also remove them from the output file.  
{: .challenge}

## Process Mapping Results Step 2: Re-aligning Reads

Next, we will run tool that re-aligns read to the reference genome, while correcting for misalignments around insertions and deletions. This is required in order to accurately detect variants.

> ## Hands-On: Re-aligning Reads
> Find the <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> Realign reads with LoFreq viterbi </button> tool. Run with the following parameters:
> + <span class="glyphicon glyphicon-folder-close"></span> **Reads to re-align** should be set to the output of <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> Mark Duplicates </button>. 
> + **Choose the source for the reference genome**: `History`, and the **Reference** should be the same input reference genome as for the <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> BWA-MEM </button> step. 
> + Check that **Advanced Options**: "_How to handle base qualities of 2?_" is set to `Keep Unchanged`. 
{: .challenge}

## Process Mapping Results Step 3: Adding Indel Qualities

This step adds indel qualities into our alignment file. These are a measurement of how certain lofreq is that an insertion or deletion is "real", and not just an artifact of sequencing or mapping. This is necessary in order to call variants. 

> ## Hands-On: Add indel qualities with lofreq
> Find the <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> Insert indel qualities into a BAM file </button> tool. Run with the following parameters:
> +  <span class="glyphicon glyphicon-folder-close"></span> **Reads**: `realigned`, and select output of <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> Realign reads </button>. 
> + **Indel calculation approach**: `Dindel`. 
> + **Choose the source for the reference genome**: `History`, and the **Reference** should be the same input reference genome as for the <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> BWA-MEM </button> step. 
{: .challenge}

Now we are ready to actually call our variants!

## The Actual Variant-Calling
 
Add more details here about what variant-calling actually does! 

> ## Hands On: Call variants using lofreq
> Find and run <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> Call variants with LoFreq </button> with the following parameters: 
> +  <span class="glyphicon glyphicon-folder-close"></span> **Input reads in BAM format**: select output of <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> Insert indel qualities </button>. 
> + **Choose the source for the reference genome**: `History`, and the **Reference** should be the same input reference genome as for the <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> BWA-MEM </button> step. 
> + **Call variants across**: `Whole reference`
> + **Types of variants to call**: `SNVs and indels`
> + Go into **Variant calling parameters**: Configure settings
> + In **Coverage**:
>   + _Minimal coverage_: `50`
> + In **Base-calling quality**:
>   + _Minimum baseQ_: `30`
>   + _Minimum baseQ for alternate bases_: `30`
> + In **Mapping quality**:
>   + _Minimum mapping quality_: `20`
> + **Variant filter parameters**: Preset filtering on QUAL score + coverage + strand bias (lofreq call default)
>
> Once those are all set, click `Execute`!
{: .challenge}

Once this has run, we have now found many places in the genome where your sample differs from the reference genome - this is where we are right now after calling variants. Variants can be categorized as follows:

+ SNP (Single-Nucleotide Polymorphism) Reference = 'A', Sample = 'C'
+ Ins (Insertion) Reference = 'A', Sample = 'AGT'
+ Del (Deletion) Reference = 'AC', Sample = 'C'
+ MNP (Multiple-nucleotide polymorphism) Reference = 'ATA', Sample = 'GTC'
+ MIXED (Multiple-nucleotide and an InDel) Reference = 'ATA', Sample = 'GTCAGT'

<img src="{{ page.root }}/fig/Types-of-Genetic-Variations.png" alt="Cartoon diagram of different types of genetic variants using the sentence 'The Sky is Blue' ">

**Figure Caption**: Examples of types of sequence variants. For now, we are not looking specifically for tandem repeats and copy number variants. From Philibert et al. 2014.

## Getting ready to interpret our variant-calling results

So, we have variant-calling results, but they are not particular useful, for us as humans, to look at yet. So, we are going to add information about the biological relevance of variants by **annotating variant effects**, and then creating an organized table of variants by **extracting fields** from the table of annotation information. Finally, we will **collapse the collection** of final, annotated results for the two datasets we originally downloaded from NCBI SRA to make them even easier for us to use. 

To annotate variant effects, we are using software called **SnpEff** (i.e. "SNP effects"), which annotates and predicts the effects of genetic variants (such as amino acid changes). Using our variant-calling, we now have a list of genetic variants in our Boston SARS-CoV-2 samples as compared with the `Wuhan-Hu-1` reference genome. But say want to know more about these variants than just their genetic coordinates. E.g.: Are they in a gene? In an exon? Do they change protein coding? Do they cause premature stop codons? SnpEff can help you answer all these questions. The process of adding this information about the variants is called "Annotation".

**SnpEff** provides several degrees of annotations, from simple (e.g. which gene is each variant affecting) to extremely complex annotations (e.g. will this non-coding variant affect the expression of a gene?). 

Conveniently, there is a special version of **SnpEff** that is specifically calibrated for and connected to a database of known variant effects in SARS-CoV-2 genomes, which we will be using below. 

> ## Hands-On: Annotate variant effects with SnpEff
> Find and run <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> SnpEff eff: annotate variants for SARS-CoV-2 </button> and modify the following parameters:
> +  <span class="glyphicon glyphicon-folder-close"></span> **Input reads in BAM format**: select output of <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> Insert indel qualities </button>. 
> + **Select annotated Coronavirus Genome** is `NC045512.2`, which is the annotated version of the reference genome we have been using throughout. 
> + **Output format**: `VCF (only if input is VCF)`.
> + **Create CSV report Useful for downstream analysis (-csvStats)**: `Yes`
> + “Filter out specific Effects”: `No`.
{: .challenge}

> ## Hands-On: Create human-readable table of variants with SnpSift
> Find and run <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> SnpSift Extract Fields </button> and modify following the parameters:
> +  <span class="glyphicon glyphicon-folder-close"></span> **Variant input file in VCF Format**: select output of <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> SnpEff </button>. 
> +  Make sure **Fields to Extract** is as follows: `CHROM POS REF ALT QUAL DP AF SB DP4 EFF[*].IMPACT EFF[*].FUNCLASS EFF[*].EFFECT EFF[*].GENE EFF[*].CODON` Feel free to copy and paste! 
> + **One effect per line**: `Yes`. 
> + **empty text field**: `.` (just a period). 
{: .challenge}

> ## Hands-On: Collapse data into a single dataset
> Find and run <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> Collapse Collection into Single Dataset </button> and modify following the parameters:
> + <span class="glyphicon glyphicon-folder-close"></span> **Collection of files to collapse**: select output of <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> Extract Fields </button>. 
> + **Keep one header line**: `Yes`
> + **Prepend File name**: `Yes`
> + **Where to add dataset name**: `Same line and each line in dataset`.
{: .challenge}

You can see that this tool takes lines from all collection elements (in our case we have two), add element name as the first column, and pastes everything together. So if we have a collection as an input:

> ## Example of Collapse: 
> Let's say our collection element for `SRR11954102` is the following: 
> ~~~
> NC_045512.2  84 PASS  C T  960.0  28  1.0       0 0,0,15,13 MODIFIER  NONE  INTERGENIC
> NC_045512.2 241 PASS  C T 2394.0  69  0.971014  0 0,0,39,29 MODIFIER  NONE  INTERGENIC
> ~~~
> {: .output}
> And that our item for `SRR12733957`, we had: 
> ~~~
> NC_045512.2 241 PASS  C T 1954.0  63  0.888889  0 0,0,42,21 MODIFIER  NONE  INTERGENIC
> NC_045512.2 823 PASS  C T 1199.0  50  0.76      3 5,6,13,26 LOW       LOW   LOW
> ~~~
> {: .output}
> We will have a single dataset as the output, with an added column containing the dataset ID taken from the collection element names.
> ~~~
> SRR11954102 NC_045512.2  84 PASS  C T  960.0  28  1.0       0 0,0,15,13 MODIFIER  NONE  INTERGENIC
> SRR11954102 NC_045512.2 241 PASS  C T 2394.0  69  0.971014  0 0,0,39,29 MODIFIER  NONE  INTERGENIC
> SRR12733957 NC_045512.2 241 PASS  C T 1954.0  63  0.888889  0 0,0,42,21 MODIFIER  NONE  INTERGENIC
> SRR12733957 NC_045512.2 823 PASS  C T 1199.0  50  0.76      3 5,6,13,26 LOW       LOW   LOW
> ~~~
> {: .output}
> 
{: .discussion}

## Characterizing our results 

So, now we have a file containing our called variants, and their potential biological significance, for both of our input data sets, `SRR12733957` a sequencing run from a sample collected from Boston in April 2020, and `SRR11954102`, collected from Boston in May 2020. This is a file that you could manipulate in Excel or R if you already use one of those programs for statistics, but for this exercise, we are going to continue to work in Galaxy for the sake of consistency. 

Here are the columns of information that are present in our final output from  <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> Collapse Collection </button>. 

This is what the first two lines of our actual output datat set looks like: 
~~~ 
Sample	CHROM	POS	REF	ALT	QUAL	DP	AF	SB	DP4	EFF[*].IMPACT	EFF[*].FUNCLASS	EFF[*].EFFECT	EFF[*].GENE	EFF[*].CODON
SRR11954102	NC_045512.2	84	C	T	7114.0	208	0.975962	0	0,1,102,105	MODIFIER	NONE	intergenic_region	CHR_START-ORF1ab	n.84C>T
SRR11954102	NC_045512.2	160	G	T	144.0	254	0.031496	14	166,77,10,0	MODIFIER	NONE	intergenic_region	CHR_START-ORF1ab	n.160G>T
~~~ 

**The first six columns are standard for variant-call-format files (VCFs):** 

| Column      | Description |
| ----------- | ----------- |
| Sample      | Sample Name      |
| CHROM       | Chromosome of reference, not really applicable for viral genomes        |
| POS         | Base pair position in reference genome  | 
| REF         | The reference allele (what the reference genome has at this position) |
| ALT         | The alternate allele (what this sample has at this position) | 
| QUAL        | Phred quality score for confidence in the variant call  | 
| DP          | Combined depth across samples | 
| AF          | Allele frequency for each ALT allele  | 
| SB          | Strand bias at position |                           
| DP4         | Depth of the reference forward, reference reverse, alternate forward, alternate reverse bases | 

**The rest of the columns contain information given to us by the SnpEff annotation process:**

| Column      | Description |
| ----------- | ----------- |
| EFF[*].IMPACT | Estimate of how likely it is that a variant will have a high impact on protein function.| 
| EFF[*].FUNCLASS | Type of mutation: NONE, SILENT, MISSENSE, NONSENSE | 
| EFF[*].EFFECT | Actual effect of this variant on protein coding (i.e. frameshift or misssense) |
| EFF[*].GENE | Gene name if in coding region.  |
| EFF[*].CODON | Codon change: old_codon > new_codon | 
 
> ## Notes about some categories
> EFF.IMPACT `MODIFIER` alleles: Usually non-coding variants or variants affecting non-coding genes, where predictions are difficult or there is no evidence of impact.
>
> EFF.GENE names: Most genes in this SARS-CoV-2 reference genome are named simply as open reading frames (ORFs)
{: .callout}

** Let's answer some questions about our data using Galaxy ** 

We are going to be using Galaxy utilities to do some tabulating and counting. 

> ## Hands on: How many variants were found in each sample?  
> We could look back at the uncollapsed files of each sample and see how many line they have, but we can also perform a single operation on the final file to get the results. 
> Find and run <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> Count occurrences of each record </button> and modify following the parameters:
> +  <span class="glyphicon glyphicon-file"></span> **From Dataset**: Our output from  <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> Collapse </button>. 
> + **Count occurrences of values in column(s)**: `Column 1`. 
> + Leave **Delimited By** and **How should the results be sorted** as is right now.
> Viewing the small output file, you should see that there are two 
> ## Solution: How many variants are associated with each gene?
> ## Solution: How many variants in each data set have a HIGH impact?  

## Hands-on: How many variants fall in the Spike Protein? 
## Solution: How many variants fall into the Spike Protein in each genotype? 

## Solution: What about finding one particular mutation? 

{% include links.md %}
