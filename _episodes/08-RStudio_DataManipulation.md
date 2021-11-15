---
title: "Basic Data Manipulation in R"
teaching:
exercises: 30
questions:
- How do I get started with tabular data (e.g. spreadsheets) in R?
- What are some best practices for reading data into R?
- How do I save tabular data generated in R?
objectives:
- Be able to load a tabular dataset using base R functions
- Be able to determine the structure of a data frame including its dimensions and the datatypes of variables
- Be able to subset/retrieve values from a data frame
keypoints:
source: Rmd
editor_options: 
  markdown: 
    wrap: 72
---



## Importing tabular data into R

There are several ways to import data into R. For our purpose here, we
will focus on using the tools every R installation comes with (so called
"base" R) to import a tab-delimited file containing results from our
differential expression workflow. We will need to load the sheet using a
function called `read.table()`.

> ## Exercise: Review the arguments of the `read.table()` function
>
> **Before using the `read.table()` function, use R's help feature to
> answer the following questions**.
>
> *Hint*: Entering '?' before the function name and then running that
> line will bring up the help documentation. Also, when reading this
> particular help be careful to pay attention to the 'read.table'
> expression under the 'Usage' heading. Other answers will be in the
> 'Arguments' heading.
>
> A)  What is the default parameter for 'header' in the `read.table()`
>     function?
>
> B)  What argument would you have to change to read a file that was
>     delimited by semicolons (;) rather than a space?
>
> C)  What argument would you have to change to read file in which
>     numbers used commas for decimal separation (i.e. 1,00)?
>
> D)  What argument would you have to change to read in only the first
>     10,000 rows of a very large file?
>
> > ## Solution
> >
> > A)  The `read.table()` function has the argument 'header' set to
> >     TRUE by default, this means the function always assumes the
> >     first row is header information, (i.e. column names)
> >
> > B)  The `read.table()` function has the argument 'sep' set to " ".
> >     This means the function assumes spaces are used as delimiters,
> >     as you would expect. Changing this parameter (e.g. `sep=";"`)
> >     would now interpret semicolons as delimiters.
> >
> > C)  If you set `dec=","` you could change the decimal operator. We'd
> >     probably assume the delimiter is some other character.
> >
> > D)  You can set `nrow` to a numeric value (e.g. `nrow=10000`) to
> >     choose how. many rows of a file you read in. This may be useful
> >     for very large files where not all the data is needed to test
> >     some data cleaning steps you are applying.
> >
> > Hopefully, this exercise gets you thinking about using the provided
> > help documentation in R. There are many arguments that exist, but
> > which we wont have time to cover. Look here to get familiar with
> > functions you use frequently, you may be surprised at what you find
> > they can do. 
> {: .solution}
{: .challenge}

Now, let's read in the file `pregnant_lactate_sample.csv`, which
contains just 1000 random lines from the final `limma-voom` expression
table for that data set. Call this data `pregnant_lactate_sample`. The
first argument to pass to our `read.table()` function is the file path
for our data. The file path must be in quotes and now is a good time to
remember to use tab autocompletion. **If you use tab autocompletion you
avoid typos and errors in file paths.** Use it!


```r
# Note that that despite this being labeled as a ".csv" file, it is actually delimited by a tab, which you can specific with a "\t" separator. Never trust data at face value!
pregnant_lactate_sample <- read.csv("pregnant_lactate_sample.csv", sep="\t")
```

One of the first things you should notice is that in the Environment
window, you have the `pregnant_lactate_sample` object, listed as 1000
obs. (observations/rows) of 9 variables (columns). Double-clicking on
the name of the object will open a view of the data in a new tab.

<img src="{{ page.root }}/fig/pregnant_lactate_samples.png" width="1000" alt="RStudio with loaded data frame">

A **data frame is the standard way in R to store tabular data**. A data
fame could also be thought of as a collection of vectors, all of which
have the same length. Using only a few functions, we can learn a lot
about out data frame including some summary statistics as well as well
as the "structure" of the data frame. Let's examine what each of these
functions can tell us:


```r
nrow(pregnant_lactate_sample)
```

```
## [1] 1000
```

```r
ncol(pregnant_lactate_sample)
```

```
## [1] 9
```

First, we can simply use the `nrow` and `ncol` functions to query how
many rows and columns a data frame has. This may not SEEM particularly
interesting, but it is extremely useful in functions that rely on doing
something like iterating over each row.


```r
summary(pregnant_lactate_sample)
```

```
##     ENTREZID            SYMBOL            GENENAME             logFC         
##  Min.   :    11364   Length:1000        Length:1000        Min.   :-3.23106  
##  1st Qu.:    22324   Class :character   Class :character   1st Qu.:-0.32135  
##  Median :    69722   Mode  :character   Mode  :character   Median :-0.01463  
##  Mean   :  4424708                                         Mean   : 0.05394  
##  3rd Qu.:   217001                                         3rd Qu.: 0.34181  
##  Max.   :100862074                                         Max.   : 5.15070  
##     AveExpr             t                P.Value           adj.P.Val      
##  Min.   :-1.706   Min.   :-15.46026   Min.   :0.000000   Min.   :0.00000  
##  1st Qu.: 1.831   1st Qu.: -1.85031   1st Qu.:0.004722   1st Qu.:0.01814  
##  Median : 4.041   Median : -0.08661   Median :0.080339   Median :0.15510  
##  Mean   : 3.804   Mean   :  0.10736   Mean   :0.230354   Mean   :0.28677  
##  3rd Qu.: 5.667   3rd Qu.:  1.92966   3rd Qu.:0.377505   3rd Qu.:0.50031  
##  Max.   :11.233   Max.   : 21.43419   Max.   :0.999746   Max.   :0.99978  
##        B         
##  Min.   :-7.403  
##  1st Qu.:-6.396  
##  Median :-5.217  
##  Mean   :-4.026  
##  3rd Qu.:-2.600  
##  Max.   :16.552
```

Our data frame had 9 variables, so we get 9 fields that summarize the
data. The `LogFC`, `AveExpr`, and `P.value` variables (and several
others) are numerical data and so you get summary statistics on the min
and max values for these columns, as well as mean, median, and
interquartile ranges. Many of the other variables (e.g. `SYMBOL`) are
treated as character data. **Note**: Even though you shouldn't actually
do math or other manipulations on the `ENTREZID` variable, since R only
finds numbers in that column, it automatically assumes it is numeric and
tries to calculate summary stats.

Now, let's use the `str()` (structure) function to look a little more
closely at how data frames work:


```r
## get the structure of a data frame
str(pregnant_lactate_sample)
```

```
## 'data.frame':	1000 obs. of  9 variables:
##  $ ENTREZID : int  100503377 269003 66403 76223 108115 26931 20832 21846 66230 108058 ...
##  $ SYMBOL   : chr  NA "Sap130" "Asf1a" "Agbl3" ...
##  $ GENENAME : chr  NA "Sin3A associated protein" "anti-silencing function 1A histone chaperone" "ATP/GTP binding protein-like 3" ...
##  $ logFC    : num  0.999 0.102 0.241 -0.272 0.447 ...
##  $ AveExpr  : num  2.05 5.91 3.25 1.77 2.92 ...
##  $ t        : num  4.094 0.857 1.274 -1.015 2.413 ...
##  $ P.Value  : num  0.00115 0.40622 0.22391 0.3278 0.03051 ...
##  $ adj.P.Val: num  0.00617 0.52872 0.33765 0.44929 0.07379 ...
##  $ B        : num  -0.926 -7.008 -6.129 -6.078 -4.296 ...
```

Ok, thats a lot up unpack! Some things to notice.

-   the object type `data.frame` is displayed in the first row along
    with its dimensions, in this case 1000 observations (rows) and 9
    variables (columns).

-   Each variable (column) has a name (e.g. `ENTREZID`). This is
    followed by the object mode (e.g. chr, int, etc.). Notice that
    before each variable name there is a `$` - this will be important
    later.

**As a reminder, here is the interpretation of those variables:**

| **Limma-voom output column** | **Explanation** | 
| ENTREZID | NCBI Entrez ID for this differentially expressed gene | 
| SYMBOL | Abbreviated gene name | 
| GENENAME | Full gene name | 
| logFC | log(2) fold change between the two experimental conditions (basalpregnant vs. basallactate) |
| AveExpr | Average log(2)fold change across all samples in comparison | 
| t | moderated t-statistic: t-statistic like those for a normal t-test, adjusted for aspects of the experiment | 
| P.value | P-value associated with the above t-statistic | 
| adj.P.value | p-value adjusted for multiple testing | 
| B | B-statistic is the log-odds that the gene is differentially expressed. For reference, a B-statistic of 0 corresponds to a 50-50 chance that the gene is differentially expressed. | 


## Working with Vectors in R:

We can think of each variable (column) of data in a `data.frame` as its
own independent `**vector**` storing a different piece of data for each
sample. Vectors are probably the most used commonly used object type in
R. A vector is a collection of values that are all of the same type
(numbers, characters, etc.). We can extract individual variables into
vectors using the `$` operator.


```r
# Use the $ sign operator
log_fc <- pregnant_lactate_sample$logFC

str(log_fc)
```

```
##  num [1:1000] 0.999 0.102 0.241 -0.272 0.447 ...
```

We can see that the vector log_fc now contains the LogFC data from our
data frame, stored as a numeric vector. Vectors always have a mode and a
length. You can check these with the mode() and length() functions
respectively.


```r
mode(log_fc)
```

```
## [1] "numeric"
```

```r
length(log_fc)
```

```
## [1] 1000
```

### Creating and subsetting vectors

Let's create a few more vectors to play around with:


```r
# Some interesting human SNPs
# while accuracy is important, typos in the data won't hurt you here

snp_genes <- c("OXTR", "ACTN3", "AR", "OPRM1")
snps <- c('rs53576', 'rs1815739', 'rs6152', 'rs1799971')
snp_chromosomes <- c('3', '11', 'X', '6')
snp_positions <- c(8762685, 66560624, 67545785, 154039662)
```

Once we have vectors, one thing we may want to do is specifically
retrieve one or more values from our vector. To do so, we use **bracket
notation**. We type the name of the vector followed by square brackets.
In those square brackets we place the index (e.g. a number) in that
bracket as follows:


```r
# get the 3rd value in the snp_genes vector
snp_genes[3]
```

```
## [1] "AR"
```
<br/><br/>
In R, every item your vector is indexed, starting from the first item
(1) through to the final number of items in your vector. You can also
retrieve a range of numbers:


```r
# get the 1st through 3rd value in the snp_genes vector

snp_genes[1:3]
```

```
## [1] "OXTR"  "ACTN3" "AR"
```
<br/><br/>
If you want to retrieve several (but not necessarily sequential) items
from a vector, you pass a **vector of indices**; a vector that has the
numbered positions you wish to retrieve.


```r
# get the 1st, 3rd, and 4th value in the snp_genes vector

snp_genes[c(1, 3, 4)]
```

```
## [1] "OXTR"  "AR"    "OPRM1"
```
<br/><br/>
There are additional (and perhaps less commonly used) ways of subsetting
a vector (see [these
examples](https://thomasleeper.com/Rcourse/Tutorials/vectorindexing.html)).
Also, several of these subsetting expressions can be combined:


```r
# get the 1st through the 3rd value, and 4th value in the snp_genes vector
# yes, this is a little silly in a vector of only 4 values.
snp_genes[c(1:3,4)]
```

```
## [1] "OXTR"  "ACTN3" "AR"    "OPRM1"
```

## Adding to, removing, or replacing values in existing vectors
<br/><br/>
Once you have an existing vector, you may want to add a new item to it.
To do so, you can use the `c()` function again to add your new value:


```r
# add the gene 'CYP1A1' and 'APOA5' to our list of snp genes
# this overwrites our existing vector
snp_genes <- c(snp_genes, "CYP1A1", "APOA5")
```
<br/><br/>
We can verify that "snp_genes" contains the new gene entry


```r
snp_genes
```

```
## [1] "OXTR"   "ACTN3"  "AR"     "OPRM1"  "CYP1A1" "APOA5"
```
<br/><br/>
Using a negative index will return a version of a vector with that
index's value removed:


```r
snp_genes[-6]
```

```
## [1] "OXTR"   "ACTN3"  "AR"     "OPRM1"  "CYP1A1"
```
<br/><br/>
We can remove that value from our vector by overwriting it with this
expression:


```r
snp_genes <- snp_genes[-6]
snp_genes
```

```
## [1] "OXTR"   "ACTN3"  "AR"     "OPRM1"  "CYP1A1"
```
<br/><br/>
We can also explicitly rename or add a value to our index using double
bracket notation:


```r
snp_genes[7]<- "APOA5"
snp_genes
```

```
## [1] "OXTR"   "ACTN3"  "AR"     "OPRM1"  "CYP1A1" NA       "APOA5"
```

Notice in the operation above that R inserts an `NA` value to extend our
vector so that the gene "APOA5" is an index 7. This may be a good or
not-so-good thing depending on how you use this.
<br/><br/>
> ## Exercise: Examining and subsetting vectors
>
> Answer the following questions to test your knowledge of vectors. **Which of the following are true of vectors in R?** 
> 
> A) All vectors have a mode **or** a length.
> 
> B) All vectors have a mode **and** a length.
> 
> C) Vectors may have different lengths.
> 
> D) Items within a vector may be of different modes.
> 
> E) You can use the `c()` to add one or more items to an existing
> vector.
> 
> F) You can use the `c()` to add a vector to an exiting vector.
> > ## Solution 
> > A) False - Vectors have both of these properties. 
> > B) True. 
> > C) True.
> > D) False - Vectors have only one mode (e.g. numeric, character); all items in a vector must be of this mode.
> > E) True. 
> > F) True.
> {: .solution} 
{: .challenge}

## Logical Subsetting

There is one last set of cool subsetting capabilities we want to
introduce. It is possible within R to retrieve items in a vector based
on a logical evaluation or numerical comparison. For example, let's say
we wanted get all of the SNPs in our vector of SNP positions that were
greater than 100,000,000. We could index using the '\>' (greater than)
logical operator:


```r
snp_positions[snp_positions > 100000000]
```

```
## [1] 154039662
```

In the square brackets you place the name of the vector followed by the
comparison operator and (in this case) a numeric value. Some of the most
common logical operators you will use in R are:

| Operator | Description              |
|----------|--------------------------|
| \<       | less than                |
| \<=      | less than or equal to    |
| \>       | greater than             |
| \>=      | greater than or equal to |
| ==       | exactly equal to         |
| !=       | not equal to             |
| !x       | not x                    |
| a \| b   | a or b                   |
| a & b    | a and b                  |

> ## The magic of programming
>
> The reason why the expression
> `snp_positions[snp_positions > 100000000]` works can be better
> understood if you examine what the expression "snp_positions \>
> 100000000" evaluates to:
>
> 
> ```r
> snp_positions > 100000000
> ```
> 
> ```
> ## [1] FALSE FALSE FALSE  TRUE
> ```
>
> The output above is a logical vector, the 4th element of which is
> TRUE. When you pass a logical vector as an index, R will return the
> true values:
>
> 
> ```r
> snp_positions[c(FALSE, FALSE, FALSE, TRUE)]
> ```
> 
> ```
> ## [1] 154039662
> ```
>
> If you have never coded before, this type of situation starts to
> expose the "magic" of programming. We mentioned before that in the
> bracket notation you take your named vector followed by brackets which
> contain an index: **named_vector[index]**. The "magic" is that the
> index needs to *evaluate to* a number. So, even if it does not appear
> to be an integer (e.g. 1, 2, 3), as long as R can evaluate it, we will
> get a result. That our expression
> `snp_positions[snp_positions > 100000000]` evaluates to a number can
> be seen in the following situation. If you wanted to know which
> **index** (1, 2, 3, or 4) in our vector of SNP positions was the one
> that was greater than 100,000,000?
>
> We can use the `which()` function to return the indices of any item
> that evaluates as TRUE in our comparison:
>
> 
> ```r
> which(snp_positions > 100000000)
> ```
> 
> ```
> ## [1] 4
> ```
>
> **Why this is important**
>
> Often in programming we will not know what inputs and values will be
> used when our code is executed. Rather than put in a pre-determined
> value (e.g 100000000) we can use an object that can take on whatever
> value we need. So for example:
>
> 
> ```r
> snp_marker_cutoff <- 100000000
> snp_positions[snp_positions > snp_marker_cutoff]
> ```
> 
> ```
> ## [1] 154039662
> ```
>
> Ultimately, it's putting together flexible, reusable code like this
> that gets at the "magic" of programming! 
{: .callout}

## A few final vector tricks

Finally, there are a few other common retrieve or replace operations you
may want to know about. First, you can check to see if any of the values
of your vector are missing (i.e. are `NA`). Missing data will get a more
detailed treatment later, but the `is.NA()` function will return a
logical vector, with TRUE for any NA value:


```r
# current value of 'snp_genes': 
# chr [1:7] "OXTR" "ACTN3" "AR" "OPRM1" "CYP1A1" NA "APOA5"

is.na(snp_genes)
```

```
## [1] FALSE FALSE FALSE FALSE FALSE  TRUE FALSE
```
<br/><br/>
Sometimes, you may wish to find out if a specific value (or several
values) is present a vector. You can do this using the comparison
operator `%in%`, which will return TRUE for any value in your collection
that is in the vector you are searching:


```r
# current value of 'snp_genes':
# chr [1:7] "OXTR" "ACTN3" "AR" "OPRM1" "CYP1A1" NA "APOA5"

# test to see if "ACTN3" or "APO5A" is in the snp_genes vector
# if you are looking for more than one value, you must pass this as a vector

c("ACTN3","APOA5") %in% snp_genes
```

```
## [1] TRUE TRUE
```

## Subsetting Data Frames

The first thing to remember is that a data frame is two-dimensional
(rows and columns). Therefore, to select a specific value we will will
once again use [] (bracket) notation, but we will specify more than one
value (except in some cases where we are taking a range).
<br/><br/>
> ## Exercise: Subsetting a data frame
>
> **Try the following indices and functions and try to figure out what
> they return**
>
> a.  `pregnant_lactate_sample[1,1]`
>
> b.  `pregnant_lactate_sample[2,4]`
>
> c.  `pregnant_lactate_sample[1000,9]`
>
> d.  `pregnant_lactate_sample[2, ]`
>
> e.  `head(pregnant_lactate_sample[-1, ])`
>
> f.  `pregnant_lactate_sample[1:4,1]`
>
> g.  `pregnant_lactate_sample[,c("P.Value")]`
>
> h.  `head(pregnant_lactate_sample)`
>
> i.  `tail(pregnant_lactate_sample)`
>
> j.  `pregnant_lactate_sample$SYMBOL`
>
> k.  `pregnant_lactate_sample[pregnant_lactate_sample$SYMBOL == "Agbl3",]`
>
> > ## Solution
> >
> > a.  
> >
> > 
> > ```
> > ## [1] 100503377
> > ```
> >
> > b.  
> >
> > 
> > ```
> > ## [1] 0.101973
> > ```
> >
> > c.  
> >
> > 
> > ```
> > ## [1] -6.398961
> > ```
> >
> > d.  
> >
> > 
> > ```
> > ##   ENTREZID SYMBOL                 GENENAME    logFC AveExpr         t   P.Value
> > ## 2   269003 Sap130 Sin3A associated protein 0.101973 5.90508 0.8570232 0.4062199
> > ##   adj.P.Val         B
> > ## 2 0.5287194 -7.007641
> > ```
> >
> > e.  
> >
> > 
> > ```
> > ##   ENTREZID  SYMBOL                                                    GENENAME
> > ## 2   269003  Sap130                                    Sin3A associated protein
> > ## 3    66403   Asf1a                anti-silencing function 1A histone chaperone
> > ## 4    76223   Agbl3                              ATP/GTP binding protein-like 3
> > ## 5   108115 Slco4a1 solute carrier organic anion transporter family, member 4a1
> > ## 6    26931 Ppp2r5c         protein phosphatase 2, regulatory subunit B', gamma
> > ## 7    20832    Ssr4                             signal sequence receptor, delta
> > ##        logFC  AveExpr          t   P.Value   adj.P.Val         B
> > ## 2  0.1019730 5.905080  0.8570232 0.4062199 0.528719445 -7.007641
> > ## 3  0.2408268 3.250726  1.2740289 0.2239075 0.337646175 -6.129292
> > ## 4 -0.2718800 1.766450 -1.0148846 0.3278042 0.449286598 -6.078261
> > ## 5  0.4470426 2.915509  2.4128361 0.0305105 0.073790047 -4.296022
> > ## 6 -0.1748803 6.717637 -1.6226379 0.1275155 0.220685922 -6.120119
> > ## 7  0.6628687 5.651834  5.9213165 0.0000413 0.000556757  1.885726
> > ```
> >
> > f.  
> >
> > 
> > ```
> > ## [1] 100503377    269003     66403     76223
> > ```
> >
> > g.  
> >
> > 
> > ```
> > ## [1] 0.001149596 0.406219916 0.223907466 0.327804192 0.030510497 0.127515480
> > ```
> >
> > h.  
> >
> > 
> > ```
> > ## Error in head(variants): object 'variants' not found
> > ```
> >
> > i.  
> >
> > 
> > ```
> > ## Error in tail(variants): object 'variants' not found
> > ```
> >
> > j.  
> >
> > 
> > ```
> > ## [1] NA        "Sap130"  "Asf1a"   "Agbl3"   "Slco4a1" "Ppp2r5c"
> > ```
> >
> > k.  
> >
> > 
> > ```
> > ##       ENTREZID SYMBOL                       GENENAME    logFC AveExpr         t
> > ## NA          NA   <NA>                           <NA>       NA      NA        NA
> > ## 4        76223  Agbl3 ATP/GTP binding protein-like 3 -0.27188 1.76645 -1.014885
> > ## NA.1        NA   <NA>                           <NA>       NA      NA        NA
> > ## NA.2        NA   <NA>                           <NA>       NA      NA        NA
> > ## NA.3        NA   <NA>                           <NA>       NA      NA        NA
> > ## NA.4        NA   <NA>                           <NA>       NA      NA        NA
> > ## NA.5        NA   <NA>                           <NA>       NA      NA        NA
> > ## NA.6        NA   <NA>                           <NA>       NA      NA        NA
> > ## NA.7        NA   <NA>                           <NA>       NA      NA        NA
> > ## NA.8        NA   <NA>                           <NA>       NA      NA        NA
> > ## NA.9        NA   <NA>                           <NA>       NA      NA        NA
> > ## NA.10       NA   <NA>                           <NA>       NA      NA        NA
> > ## NA.11       NA   <NA>                           <NA>       NA      NA        NA
> > ## NA.12       NA   <NA>                           <NA>       NA      NA        NA
> > ## NA.13       NA   <NA>                           <NA>       NA      NA        NA
> > ##         P.Value adj.P.Val         B
> > ## NA           NA        NA        NA
> > ## 4     0.3278042 0.4492866 -6.078261
> > ## NA.1         NA        NA        NA
> > ## NA.2         NA        NA        NA
> > ## NA.3         NA        NA        NA
> > ## NA.4         NA        NA        NA
> > ## NA.5         NA        NA        NA
> > ## NA.6         NA        NA        NA
> > ## NA.7         NA        NA        NA
> > ## NA.8         NA        NA        NA
> > ## NA.9         NA        NA        NA
> > ## NA.10        NA        NA        NA
> > ## NA.11        NA        NA        NA
> > ## NA.12        NA        NA        NA
> > ## NA.13        NA        NA        NA
> > ```
> >
> {: .solution} 
{: .challenge}
<br/><br/>
**The subsetting notation is very similar to what we learned for
vectors. The key differences include:**

-   Typically provide two values separated by commas: data.frame[row,
    column].
-   In cases where you are taking a continuous range of numbers use a
    colon between the numbers (start:stop, inclusive).
-   For a non continuous set of numbers, pass a vector using `c()`.
-   Index using the name of a column(s) by passing them as vectors using
    `c()`.
<br/><br/>

**Finally, in all of the subsetting exercises above, we printed values
to the screen. You can create a new data frame object by assigning them
to a new object name:**
<br/><br/>
Create a new data frame containing only those genes with an adjusted
P-value less than or equal to 0.05:


```r
# Notice that we need to refer to the correct variable using the `$` operator.
# And also that we use the "," to say that we are selecting ROWS instead of columns. The condition would go AFTER the column for selecting rows. 
pregnant_lactate_sample_filt <- pregnant_lactate_sample[pregnant_lactate_sample$adj.P.Val <= 0.05,]

# check the dimension of the data frame

dim(pregnant_lactate_sample_filt)
```

```
## [1] 353   9
```

```r
# get a summary of the data frame

summary(pregnant_lactate_sample_filt)
```

```
##     ENTREZID            SYMBOL            GENENAME             logFC        
##  Min.   :    11429   Length:353         Length:353         Min.   :-3.2311  
##  1st Qu.:    20308   Class :character   Class :character   1st Qu.:-0.6121  
##  Median :    67980   Mode  :character   Mode  :character   Median : 0.3464  
##  Mean   :  3513354                                         Mean   : 0.1694  
##  3rd Qu.:   214901                                         3rd Qu.: 0.8262  
##  Max.   :100529075                                         Max.   : 5.1507  
##     AveExpr             t              P.Value            adj.P.Val        
##  Min.   :-1.706   Min.   :-15.460   Min.   :0.0000000   Min.   :3.000e-08  
##  1st Qu.: 2.485   1st Qu.: -3.658   1st Qu.:0.0001143   1st Qu.:1.140e-03  
##  Median : 4.584   Median :  2.818   Median :0.0014143   Median :7.241e-03  
##  Mean   : 4.210   Mean   :  0.397   Mean   :0.0038052   Mean   :1.300e-02  
##  3rd Qu.: 5.965   3rd Qu.:  4.401   3rd Qu.:0.0063033   3rd Qu.:2.247e-02  
##  Max.   :11.233   Max.   : 21.434   Max.   :0.0182144   Max.   :4.970e-02  
##        B         
##  Min.   :-4.307  
##  1st Qu.:-2.747  
##  Median :-1.505  
##  Mean   :-0.500  
##  3rd Qu.: 1.121  
##  Max.   :16.552
```

```r
#We can see that 353 of the 1000 genes in this table are significant at the P=0.05 level!
```

## Comparing data sets in R

**One of the really powerful uses of R is being able to really quickly
compare data frames without much manual work on your end. Try the
following on your own to create a data frame we can compare with the
`pregnant_lactate_sample_filt` data set:**

1.  Import the `virgin_pregnant_sample.csv` into R, creating a
    `data frame` called `virgin_pregnant_sample`.
2.  Filter this data frame so that it includes only genes an adjusted
    P-value less than or equal to 0.05, creating a dataframe called
    `virgin_pregnant_sample_filt`.
3.  Report a summary of this new data frame.

> ## Solution
>
> Use the following commands:
>
> 
> ```r
> virgin_pregnant_sample <- read.csv("virgin_pregnant_sample.csv", sep="\t")
> virgin_pregnant_sample_filt <- virgin_pregnant_sample[virgin_pregnant_sample$adj.P.Val <= 0.05,]
> summary(virgin_pregnant_sample_filt)
> ```
>
> You should see that this table contains 269 rows of data.
>
{: .solution}

**Now, let's try to answer a question that I am sure you are very
curious about: How many significant genes do these two data sets have in
common?**
<br/><br/>
Base R has a few very useful set operations built in for answering this
sort of question. We are going to use the `intersect()`function to creat
a vector of the genes that have in common:


```r
overlap <- intersect(pregnant_lactate_sample_filt$ENTREZID,virgin_pregnant_sample_filt$ENTREZID)
```

```
## Error in as.vector(y): object 'virgin_pregnant_sample_filt' not found
```

```r
## Let's see how big the overlap is 
length(overlap) #They share 10 differentially expressed genes
```

```
## Error in eval(expr, envir, enclos): object 'overlap' not found
```
<br/><br/>
We can also perform other set operations, such as `union()`, which
creates a list of all elements in either list, and `setdiff()` which
computes the list of elements in one list but not in the other:


```r
# We can nest the union() function inside the length() function to cut out an intermediate step
length(union(pregnant_lactate_sample_filt$ENTREZID,virgin_pregnant_sample_filt$ENTREZID))
```

```
## Error in as.vector(y): object 'virgin_pregnant_sample_filt' not found
```

```r
# Note that reversing the arguments on setdiff() produces different results: 
length(setdiff(pregnant_lactate_sample_filt$ENTREZID,virgin_pregnant_sample_filt$ENTREZID))
```

```
## Error in as.vector(y): object 'virgin_pregnant_sample_filt' not found
```

```r
length(setdiff(virgin_pregnant_sample_filt$ENTREZID,pregnant_lactate_sample_filt$ENTREZID))
```

```
## Error in as.vector(x): object 'virgin_pregnant_sample_filt' not found
```
<br/><br/>
Now, let's say that we want to not only get the list of the overlap
between the significant genes, but also extract the rows from each data
frame that correspond to those overlapping genes.

We can do this with the `%in%` operator:


```r
# select the rows in the pregnant_lactate_sample_filt data frame that correspond to those 10 shared genes 
preg_lac_overlap <- pregnant_lactate_sample_filt[pregnant_lactate_sample_filt$ENTREZID %in% overlap,]
```

```
## Error in pregnant_lactate_sample_filt$ENTREZID %in% overlap: object 'overlap' not found
```

```r
summary(preg_lac_overlap)
```

```
## Error in summary(preg_lac_overlap): object 'preg_lac_overlap' not found
```

```r
# select the rows in the virgin_pregnant_sample_filt data frame that correspond to those 10 shared genes
virg_preg_overlap <- virgin_pregnant_sample_filt[virgin_pregnant_sample_filt$ENTREZID %in% overlap,]
```

```
## Error in eval(expr, envir, enclos): object 'virgin_pregnant_sample_filt' not found
```

```r
summary(virg_preg_overlap)
```

```
## Error in summary(virg_preg_overlap): object 'virg_preg_overlap' not found
```
<br/><br/>
You can also cut out the step of creating the `overlap` vector by
telling the %in% operator to compare the two columns of data directly,
using a command like the one below:


```r
virg_preg_overlap <- virgin_pregnant_sample_filt[virgin_pregnant_sample_filt$ENTREZID %in% pregnant_lactate_sample_filt$ENTREZID,]
```
<br/><br/>

> ## Challenge: How many genes are shared between the two unfiltered sample data sets?
>
> This means we want to compare the `pregnant_lactate_sample` data sets
> and the `virgin_pregnant_sample` data sets. You can do this multiple
> ways. 
> 1. Use the `interesect()` function on the `ENTREZID` columns, and get the length of the resulting vector.
> 2. Create a new data frame of the rows sharing and use summarize(), str(), or nrow() to see how many observations are in the resulting data frame. 
3. Either way, you should find that these datasets share **81** genes. 
{: .solution}
<br/><br/>

## Saving your data to a file

We can save data to a file. We will save our `virgin_pregnant_sample_filt`  object to a .csv file using the write.csv() function:
<br/><br/>
```r
write.csv(virgin_pregnant_sample_filt,"virgin_pregnant_sample_filt.csv")
```
<br/><br/>
The write.csv() function has some additional arguments listed in the help, but at a minimum you need to tell it what data frame to write to file, and give a path to a file name in quotes (if you only provide a file name, the file will be written in the current working directory). As always, you can use the `help()` function to find out all about those other parameters!

## Brief Introduction to the `dplyr` package

> ## Note
> This material is definitely outside the scope of the course - I just wanted to make you aware that this really useful package exists! However if you are already familiar with this package, feel free to use it to help you complete this assignment or your final project!
> 
{: .callout} 
<br/><br/>
When you manipulate more complicated data sets, you may want to make use
of the dplyr() package eventually. It streamlines a lot of the selecting
and filtering steps and lets you chain together lots of commands to
modify and manipulate big data frames. 
<br/><br/>
According to the main tutorial for `dplyr`, it aims to provide a
function for each basic verb of data manipulation. These verbs can be
organised into three categories based on the component of the dataset
that they work with:
<br/><br/>
**Rows**: 
* `filter()` chooses rows based on column values. 
* `slice()` chooses rows based on location. 
* `arrange()` changes the order of the rows.

**Columns:** 
* `select()` changes whether or not a column is included.
* `rename()` changes the name of columns. 
* `mutate()` changes the values of columns and creates new columns.

**The Pipe Operator** All of the dplyr functions take a data frame (or
tibble) as the first argument. Rather than forcing the user to either
save intermediate objects or nest functions, dplyr provides the `%>%`
operator. `x %>% f(y)` turns into `f(x, y)` so the result from one step
is then "piped" into the next step. You can use the pipe to rewrite
multiple operations that you can read left-to-right, top-to-bottom
(reading the pipe operator as "then").


