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
	+ Sample information file (sample id, group) - we will upload this. 
	+ Gene annotation file (gene id, symbol, description).

> ## Hands-On: Import the sample information file 
> 1. Import this file as a `tabular` file using the <span class="glyphicon glyphicon-open"></span> **Upload Data** tool. 
>    ```
>    https://esallychang.github.io/BIOF521_Fall2021/data/SampleInfo.txt
>    ```
> 2. Check that the datatype is `tabular`. If the datatype is not `tabular`, please change the file type to `tabular`.
> 3. Rename the counts dataset as `countdata` and the sample information dataset as `factordata` using the <span class="glyphicon glyphicon-pencil"></span> icon next to each data set.
> 4. The `factordata` file contains basic information about the samples that we will need for the analysis. Note that the Sample IDs must match exactly with the sample names in the counts file: 
> <img src="{{ page.root }}/fig/factor_data.png" alt="screenshot of factordata table">
{: .challenge}

### Get Gene Annotations 

Gene annotations can be provided to the **limma-voom** tool and if provided the annotation will be available in the output files. This will give us more context about the potentially interesting functions of the differentially expressed genes than a list of relatively anonymous Entrez gene IDs would otherwise gives us. We’ll get gene symbols and descriptions for these genes using the Galaxy <button type="button" class="btn btn-outline-tool" style="pointer-events: none"> annotateMyIDs </button> tool, which can provide annotations for human, mouse, fruitfly and zebrafish.

