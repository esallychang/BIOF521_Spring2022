---
title: "Hands On: Creating Counts from Mapped Reads" 
exercises: 90
objectives:
  - "Analysis of RNA-seq count data using limma-voom"
  - "QC of count data"
  - "Visualisation and interactive exploration of count data"
  - "Identification of differentially expressed genes"
time_estimation: "2h"
key_points:
  - "The limma-voom tool can be used to perform differential expression and output useful plots"
  - "Multiple comparisons can be input and compared"
  - "Results can be interactively explored with limma-voom via Glimma"
---

In this tutorial, we will deal with:

1. Preparing the inputs
	+ Get gene annotations
2. Differential expression with limma-voom
	+ Filtering to remove lowly expressed genes
	+ Normalization for composition bias
	+ Specify Contrast(s) of interest
3. QC of count data
	+ Multidimensional scaling plot
	+ Density plots
	+ Box plots
	+ Voom variance plot
	+ MD and Volcano plots for DE results
4. Testing relative to a threshold (TREAT)
5. Visualing results 
	+ Visualising results
	+ Heatmap of top genes
	+ Stripcharts of top genes
	+ Interactive DE plots (Glimma)

> ## Heads up: Results may vary!
> It is possible that your results may be **slightly** different from the ones presented in this tutorial due to differing versions of tools, reference data, external databases, or because of stochastic processes in the algorithms.
{: .callout}

## Preparing the Inputs

**We will use three files for this analysis:**
	+ Count matrix (genes in rows, samples in columns) - we created this in the previous tutorial. 
	+ Sample information file (sample id, group).
	+ Gene annotation file (gene id, symbol, description).

> ## Hands-On: Import the sample information file 
> 1. Import this file as a `tabular` file using the <span class="glyphicon glyphicon-open"></span> **Upload Data** tool. 
>    ```
>    https://sourceforge.net/projects/rseqc/files/BED/Mouse_Mus_musculus/mm10_RefSeq.bed.gz/download
>    ```