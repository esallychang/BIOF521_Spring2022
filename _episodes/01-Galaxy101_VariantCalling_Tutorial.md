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

In order to see what mutations the Boston strains of SARS-CoV-2 have accumulated relative to the original strain isolated from patients from Wuhan, China, we are going to map our filtered sequencing data to the full assembled genome of one of the original SARS-CoV-2 isolates, `Wuhan-Hu-1`. It has an accession ID of `NC_045512.2`, which you can search for on NCBI much like we did for the Boston samples to get more information. 

> ## Hands-On: Importing the reference genome from NCBI
> 1. Click the **Upload Data** button in the toolbar.
> 2. In the menu that pops up, click on **Paste/Fetch Data** 
> 3. Copy and paste this address in the box: `https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/009/858/895/GCF_009858895.2_ASM985889v3/GCF_009858895.2_ASM985889v3_genomic.fna.gz`
> <img src="{{ page.root }}/fig/paste_fetch_data_box.png" alt="Galaxy fetch data window with address in the box">
> 4. Replace `New File` with something sensible, like `Reference Genome`, and press `Start`. You can close the window now.
{: .challenge}

Assembled genomes are often stored as `FASTA` files, which can store any type of sequence data, as long as each sequence is stored with a header line, which are denoted with a 


{% include links.md %}
