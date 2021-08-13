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


> ## "Process and filter SraRunInfo.csv"
>
> This is the tool we are going to use <button type="button" class="btn btn-outline-tool" style="pointer-events: none">  Select Text  </button>
> ~~~
> it may include some code
> ~~~
> {: .source}
>
> > ## Solution
> >
> > This is the body of the solution.
> >
> > ~~~
> > it may also include some code
> > ~~~
> > {: .output}
> {: .solution}
{: .challenge}


{% include links.md %}
