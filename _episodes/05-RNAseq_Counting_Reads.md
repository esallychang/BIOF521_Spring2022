---
title: "Hands On: Creating Counts from Mapped Reads" 
exercises: 30
objectives:
- "Learn how RNA-seq reads are converted into counts"
- "Create a Galaxy Workflow that converts RNA-seq reads into counts"
keypoints:
- "PLEASE EDIT ME"
---

## Counting

The alignment produces a set of BAM files, where each file contains the read alignments for each sample. In the BAM file, there is a chromosomal location for every read that mapped. Now that we have figured out where each read comes from in the genome, we need to summarise the information across genes or exons. The mapped reads can be counted across mouse genes by using a tool called **featureCounts**. featureCounts requires gene annotation specifying the genomic start and end position of each exon of each gene. For convenience, featureCounts contains built-in annotation for mouse (`mm10`, `mm9`) and human (`hg38`, `hg19`) genome assemblies, where exon intervals are defined from the NCBI RefSeq annotation of the reference genome. 

Reads that map to exons of genes are added together to obtain the count for each gene, with some care taken with reads that span exon-exon boundaries. The output is a count for each Entrez Gene ID, which are numbers such as `100008567`. For other species, users will need to read in a data frame in GTF format to define the genes and exons. Users can also specify a custom annotation file in SAF format. See the tool help in Galaxy, which has an example of what an SAF file should like like, or the Rsubread users guide for more information.



> ## Hands-on: Count reads mapped to genes with **featureCounts**
> 1. Run <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> **featureCounts** </button> modifying the following parameters: 
> + *"Alignment file"*: `aligned reads (BAM)` (output of **HISAT2**). 
> + *"Gene annotation file"*: `featureCounts built-in`. 
> 	- *"Select built-in genome"*: `mm10`. 
> 
> 2. Applying the same logic as the last time we ran MultiQC, run <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> MultiQC </button> with the appropriate options for the output of **featureCounts**. 
> 3. Add a tag `#featurecounts` to the Webpage output from MultiQC and inspect the webpage. 
> 
{: .challenge} 

> ## Note: **featureCounts** parameters
> In this example we have kept many of the default settings, which are typically optimised to work well under a variety of situations. **For example, the default setting for featureCounts is that it only keeps reads that uniquely map to the reference genome. For testing differential expression of genes, this is preferred, as the reads are unambigously assigned to one place in the genome** allowing for easier interpretation of the results. Understanding all the different parameters you can change involves doing a lot of reading about the tool that you are using, and can take a lot of time to understand! We won’t be going into the details of the parameters you can change here, but you can get more information from looking at the tool help.
{: .callout}


<img src="{{ page.root }}/fig/FeatureCount_MultiQC.png" alt="Summary table FeatureCounts">

We can see from the summary that about 65% of each data set was able to be assigned uniquely to actual coding regions of the genome (exons). 

The counts for the samples are output as tabular files. Take a look at one. The numbers in the first column of the counts file represent the Entrez gene identifiers for each gene, while the second column contains the counts for each gene for the sample.

More about Entrez Gene IDs here: 

> ## Hands-On: Finding out more about a gene
> 1. Let's look at the first gene in the mapping output for `SRR1552452`. For me (it may vary), it is an ID number of `497097`, and there are `65` reads which have mapped to it. 
> 2. Go to https://www.ncbi.nlm.nih.gov/.
> 3. In the search bar, enter `497097` and choose `Gene` in the dropdown menu next to the search bar. 
> 4. This number can be found in multiple databases, so click on the `Gene` results. 
> 5. We can see that this gene is `Xkr4`, or `X-linked Kx blood group related 4`. 
> 6. This page also serves as a portal for A LOT of other information about the gene, which may come in handy later: 
> 
> <img src="{{ page.root }}/fig/NCBI_Gene_497097.png" alt="Gene Page for Entrez ID 497097">
{: .challenge} 

## Create Count Matrix

The counts files are currently in the format of one file per sample. However, it is often convenient to have a count matrix. A count matrix is a single table containing the counts for all samples, with the genes in rows and the samples in columns. The counts files are all within a collection so we can use the Galaxy Column Join on multiple datasets tool to easily create a count matrix from the single counts files.

> ## Hands-on: Create count matrix with **Column Join on multiple datasets**
>
> <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> Column Join on Multiple Data Sets </button>} with the following parameters:
>    - {% icon param-collection %} *"Tabular files"*: `Counts` (output of **featureCounts** {% icon tool %})
>    - {% icon param-text %} *"Identifier column"*: `1`
>    - {% icon param-text %} *"Number of header lines in each input file"*: `1`
>    - {% icon param-check %} *"Add column name to header"*: `No`
>
{: .challenge}

The Count Matrix should look something like this, and have approximately 21,000 lines of data. 

<img src="{{ page.root }}/fig/CountMatrix_Sample.png" alt="First Lines of Gene Matrix">

> ## How do we interpret the counts for gene `100012`? 
> As you can see from the screenshot above, the read counts for each sample for this gene are 0,0,0 and 0, respectively. 
> This means that in our analysis, there are no reads associated with this particular gene in the mouse genome for any of our samples. 
> This gene will essentially be out of consideration for downstream analyses because it has no expression level (0) for all of the samples. 
{:. solution}


## Doing QC of the Read Counts

**Generating a QC summary report** 

There are several additional QCs we can perform to better understand the data, to see if it’s good quality. These can also help determine if changes could be made in the lab to improve the quality of future datasets.

We’ll use a prepared workflow to run the first few of the QCs below. This will also demonstrate how you can make use of Galaxy workflows to easily run and reuse multiple analysis steps. The workflow will run the first three tools: Infer Experiment, MarkDuplicates and IdxStats and generate a MultiQC report. You can then edit the workflow if you’d like to add other steps.

> ### {% icon hands_on %} Hands-on: Run QC report workflow
>
> 1. **Import the workflow** into Galaxy
>    - Copy the URL (e.g. via right-click) of [this workflow](https://training.galaxyproject.org/training-material/topics/transcriptomics/tutorials/rna-seq-reads-to-counts/workflows/qc_report.ga) or download it to your computer.
>    - Import the workflow into Galaxy
>
> 2. Import this file as type BED file:
>    ```
>    https://sourceforge.net/projects/rseqc/files/BED/Mouse_Mus_musculus/mm10_RefSeq.bed.gz/download
>    ```
>    {% snippet faqs/galaxy/datasets_import_via_link.md %}
>
> 3. Run **Workflow QC Report** {% icon workflow %} using the following parameters:
>    - *"Send results to a new history"*: `No`
>    - {% icon param-file %} *"1: Reference genes"*: the imported RefSeq BED file
>    - {% icon param-collection %} *"2: BAM files"*: `aligned reads (BAM)` (output of **HISAT2** {% icon tool %})
>
>    {% snippet faqs/galaxy/workflows_run.md %}
> 4. Inspect the `Webpage` output from MultiQC
{: .hands_on}
