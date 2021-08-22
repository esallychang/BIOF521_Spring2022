---
title: "Week 1 - Variant Calling in Galaxy (Practical)"
teaching: 90
exercises: 90
questions:
- "How can we best analyze our data?"
objectives:
- "Manage a Galaxy history in order to keep data organized for an analysis"
- "Load data from the NCBI SRA into the environment"
- "Identify major steps in a variant-calling workflow and their associated file types"
---

## Background

For your practical exercise this week, you will be examining more recent sequencing data sets from SARS-CoV-2 patients for the same reason many clinicians and scientists are currently looking at the same sequencing data: To see whether a particular sample belongs to a "variant of concern". According to the CDC, a [variant of concern][variant-of-concern] is one at that has " evidence of an increase in transmissibility, A variant for which there is evidence of an increase in transmissibility, more severe disease (e.g., increased hospitalizations or deaths), significant reduction in neutralization by antibodies generated during previous infection or vaccination, reduced effectiveness of treatments or vaccines, or diagnostic detection failures." Particular variants of Covid are distinguished from one another by the presence or absence of particular diagnostic mutations, some of which may actually impact features of the disease. 

At the time of writing this lesson, one of the most pressing variants of concern is the Delta (lineage B.1.617.2). More information about the Delta variant and its spread can be found here, as well as a database describing all other described lineages, can be found here: (https://cov-lineages.org/lineage.html?lineage=B.1.617.2). There are a number of other mutations in the genome of the Delta variant (as compared with the original `Wuhan-Hu-1` reference genome): 

<img src="{{ page.root }}/fig/Delta_Genome_Mutations.png" alt="Diagnostic mutations of the SARS-Cov-2 Delta variant"> 

To make this a reasonable-sized practical, we are going to focus on the mutations in the section of the SARS-CoV-2 genome encoding for the Spike protein (also known as the "S protein"). The Spike protein plays a key role in the receptor recognition and cell membrane fusion process (see below). 

<img src="{{ page.root }}/fig/SpikeProtein.png" alt="Diagram of the Sars-COV-2 spike protein and its role in binding to host cells">

**Image caption:** a: The schematic structure of the S protein. b: The S protein binds to the receptor ACE2. c: The binding and virus–cell fusion process mediated by the S protein. Ref: https://www.nature.com/articles/s41401-020-0485-4/figures/1


The Spike protein is the protein encoded by the mRNA in the mRNA-based vaccines for Covid-19. It is thought that certain mutations in the Spike protein may affect the effectiveness of these vaccines. At the time of writing, there are 10 characterized mutations in the Spike protein, of which 8 are found in at least 75% of samples taken. These are pictured in dark purple below:   


<img src="{{ page.root }}/fig/Delta_Spike_Mutations.png" alt="Diagnostic spike protein mutations of the SARS-Cov-2 Delta variant"> 

And characterized in this table. 

| Nucleotide Change    | Resultant Change|
| ----------- | ----------- |
| C21987A | G142D |
| C21618G | T19R |
| 22029-22034 Deletion | E156G/157-158 deletion | 
| T22917G | L452R |
| C22995A | T478K |
| A23403G | D614G |
| C23604G | P681R |
| G224410A | D950N |

The nomenclature is as follows. C21987A means that there is a change in nucleotides from a C (in the reference) to an A (in the sample) in nucleotide 21987 in the reference genome. This change results in an amino acid substitution in position 142 of the protein from a G (Glycine) to a D (Aspartic Acid). 

## Your task

You task this week is to employ the variant-calling pipeline you used in the tutorial on a  a set of three sequencing runs from much more recently collected samples. Using the resulting output, you will assess whether any of these samples represent the Delta variant by seeing which, if any, of the eight Spike protein mutations they possess relative to the original reference genome. **I would highly recommend that you start a clean Galaxy History for this exercise to help keep things organized!**

**SRA Sequencing Run Accession Numbers:** 
+ SRR15328723 (NYC breakthrough case)
+ SRR15315457 (Recent sample from ongoing monitoring in Bostoon)
+ SRR15364212 (Recently collected from Tennessee) 

**Reference genome:** 
+ Use the same `Wuhan-Hu-1` reference genome as for the tutorial. This can be copied into the new History you set up for this exercise. 

**Other Materials on Canvas** 
+ `SRARunInfo_Practical.csv`: Spreadsheet of run data from a number of recent samples. This will allow you to begin at the `Hands-On: Creating a subset of data` step of the tutorial. 
+ `Week1-Variant-Calling_Worksheet.docx` or `.pdf`: An assignment sheet to fill out as you progress which you will be submitting. 

**Good luck and don't hesitate to reach out with questions and use all available resources!** 

{% include links.md %}
