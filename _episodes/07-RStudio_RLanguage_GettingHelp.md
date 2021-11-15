---
title: "Introduction to R and RStudio"
teaching: 45
exercises: 10
questions:
- "How to find your way around RStudio?"
- "How to interact with R?"
- "How to manage your environment?"
- "How to install packages?"
objectives:
- "Describe the purpose and use of each pane in the RStudio IDE"
- "Locate buttons and options in the RStudio IDE"
- "Define a variable"
- "Assign data to a variable"
- "Manage a workspace in an interactive R session"
- "Use mathematical and comparison operators"
- "Call functions"
- "Manage packages"
keypoints:
- "Use RStudio to write and run R programs."
- "R has the usual arithmetic operators and mathematical functions."
- "Use `<-` to assign values to variables."
- "Use `ls()` to list the variables in a program."
- "Use `rm()` to delete objects in a program."
- "Use `install.packages()` to install packages (libraries)."
source: Rmd
---



## Introduction to RStudio

Welcome to the R portion of the Software Carpentry workshop.

Throughout this lesson, we're going to teach you some of the fundamentals of the R language as well as some best practices for organizing code for scientific projects that will make your life easier.

We'll be using RStudio: a free, open source R Integrated Development Environment (IDE). It provides a built-in editor, works on all platforms (including on servers) and provides many advantages such as integration with version control and project management.

**Basic layout**

When you first open RStudio, you will be greeted by three panels:

-   The interactive R console/Terminal (entire left)
-   Environment/History/Connections (tabbed in upper right)
-   Files/Plots/Packages/Help/Viewer (tabbed in lower right)
-   The exact files and version of R available will probably not match this exact figure, but that is okay!

![RStudio layout](../fig/rstudio_session_default.png)

Once you open files, such as R scripts, an editor panel will also open in the top left.

![RStudio labeled layout](../fig/rstudio_session_4pane_layout.png)

-   **Source**: This pane is where you will write/view R scripts. Some outputs (such as if you view a dataset using `View()`) will appear as a tab here. <br/><br/>
-   **Console/Terminal/Jobs**: This is actually where you see the execution of commands. This is the same display you would see if you were using R at the command line without RStudio. You can work interactively (i.e. enter R commands here), but for the most part we will run a script (or lines in a script) in the source pane and watch their execution and output here. The "Terminal" tab give you access to the BASH terminal (the Linux operating system, unrelated to R). RStudio also allows you to run jobs (analyses) in the background. This is useful if some analysis will take a while to run. You can see the status of those jobs in the background. <br/><br/>
-   **Environment/History**: Here, RStudio will show you what datasets and objects (variables) you have created and which are defined in memory. You can also see some properties of objects/datasets such as their type and dimensions. The "History" tab contains a history of the R commands you've executed R. <br/><br/>
-   **Files/Plots/Packages/Help/Viewer**: This multipurpose pane will show you the contents of directories on your computer. You can also use the "Files" tab to navigate and set the working directory. The "Plots" tab will show the output of any plots generated. In "Packages" you will see what packages are actively loaded, or you can attach installed packages. "Help" will display help files for R functions and packages. "Viewer" will allow you to view local web content (e.g. HTML outputs). <br/><br/>

> ## Tip: Uploads and downloads in the cloud
>
> In the "Files" tab you can select a file and download it from your cloud instance (click the "more" button) to your local computer. Uploads are also possible. 
{: .callout}

## Work flow within RStudio

There are two main ways one can work within RStudio:

1.  Test and play within the interactive R console then copy code into a .R file to run later.

    -   This works well when doing small tests and initially starting off.
    -   It quickly becomes laborious.

2.  Start writing in a .R file and use RStudio's short cut keys for the Run command to push the current line, selected lines or modified lines to the interactive R console.

    -   This is a great way to start; all your code is saved for later.
    -   You will be able to run the file you create from within RStudio or using R's `source()` function.

> ## Tip: Running segments of your code
>
> RStudio offers you great flexibility in running code from within the editor window. There are buttons, menu choices, and keyboard shortcuts. To run the current line, you can 1. click on the `Run` button above the editor panel, or 2. select "Run Lines" from the "Code" menu, or 3. hit <kbd>Ctrl</kbd>+<kbd>Return</kbd> in Windows or Linux or <kbd>⌘</kbd>+<kbd>Return</kbd> on OS X. (This shortcut can also be seen by hovering the mouse over the button). To run a block of code, select it and then `Run`. If you have modified a line of code within a block of code you have just run, there is no need to reselect the section and `Run`, you can use the next button along, `Re-run the previous region`. This will run the previous code block including the modifications you have made. 
{: .callout}

## Introduction to R

Much of your time in R will be spent in the R interactive console. This is where you will run all of your code, and can be a useful environment to try out ideas before adding them to an R script file. This console in RStudio is the same as the one you would get if you typed in `R` in your command-line environment.

The first thing you will see in the R interactive session is a bunch of information, followed by a "\>" and a blinking cursor. In many ways this is similar to the shell environment you learned about during the shell lessons: it operates on the same idea of a "Read, evaluate, print loop": you type in commands, R tries to execute them, and then returns a result.

## Using R as a calculator

The simplest thing you could do with R is to do arithmetic:


~~~
1 + 100
~~~
{: .language-r}



~~~
[1] 101
~~~
{: .output}

And R will print out the answer, with a preceding "[1]". Don't worry about this for now, we'll explain that later. For now think of it as indicating output. If you type in an incomplete command, R will wait for you to complete it. Any time you hit return and the R session shows a "+" instead of a "\>", it means it's waiting for you to complete the command. If you want to cancel a command you can hit <kbd>Esc</kbd> and RStudio will give you back the "\>" prompt.

> ## Tip: Cancelling commands
>
> If you're using R from the command line instead of from within RStudio, you need to use <kbd>Ctrl</kbd>+<kbd>C</kbd> instead of <kbd>Esc</kbd> to cancel the command. This applies to Mac users as well!
>
> Canceling a command isn't only useful for killing incomplete commands: you can also use it to tell R to stop running code (for example if it's taking much longer than you expect), or to get rid of the code you're currently writing.
>
{: .callout}

When using R as a calculator, the order of operations is the same as you would have learned back in school.

From highest to lowest precedence:

-   Parentheses: `(`, `)`
-   Exponents: `^` or `**`
-   Multiply: `*`
-   Divide: `/`
-   Add: `+`
-   Subtract: `-`


~~~
3 + 5 * 2
~~~
{: .language-r}



~~~
[1] 13
~~~
{: .output}

Use parentheses to group operations in order to force the order of evaluation if it differs from the default, or to make clear what you intend.


~~~
(3 + 5) * 2
~~~
{: .language-r}



~~~
[1] 16
~~~
{: .output}

This can get unwieldy when not needed, but clarifies your intentions. Remember that others may later read your code.


~~~
(3 + (5 * (2 ^ 2))) # hard to read
3 + 5 * 2 ^ 2       # clear, if you remember the rules
3 + 5 * (2 ^ 2)     # if you forget some rules, this might help
~~~
{: .language-r}

The text after each line of code is called a "comment". Anything that follows after the hash (or octothorpe) symbol `#` is ignored by R when it executes code.

Really small or large numbers get a scientific notation:


~~~
2/10000
~~~
{: .language-r}



~~~
[1] 2e-04
~~~
{: .output}

Which is shorthand for "multiplied by `10^XX`". So `2e-4` is shorthand for `2 * 10^(-4)`.

You can write numbers in scientific notation too:


~~~
5e3  # Note the lack of minus here
~~~
{: .language-r}



~~~
[1] 5000
~~~
{: .output}

## Mathematical functions

R has many built in mathematical functions. To call a function, we can type its name, followed by open and closing parentheses. Anything we type inside the parentheses is called the function's arguments:


~~~
sin(1)  # trigonometry functions
~~~
{: .language-r}



~~~
[1] 0.841471
~~~
{: .output}


~~~
log(1)  # natural logarithm
~~~
{: .language-r}



~~~
[1] 0
~~~
{: .output}


~~~
log10(10) # base-10 logarithm
~~~
{: .language-r}



~~~
[1] 1
~~~
{: .output}


~~~
exp(0.5) # e^(1/2)
~~~
{: .language-r}



~~~
[1] 1.648721
~~~
{: .output}

Don't worry about trying to remember every function in R. You can look them up on Google, or if you can remember the start of the function's name, use the tab completion in RStudio.

This is one advantage that RStudio has over R on its own, it has auto-completion abilities that allow you to more easily look up functions, their arguments, and the values that they take.

Typing a `?` before the name of a command will open the help page for that command. When using RStudio, this will open the 'Help' pane; if using R in the terminal, the help page will open in your browser. The help page will include a detailed description of the command and how it works. Scrolling to the bottom of the help page will usually show a collection of code examples which illustrate command usage. We'll go through an example later.

## Comparing things

We can also do comparisons in R:


~~~
1 == 1  # equality (note two equals signs, read as "is equal to")
~~~
{: .language-r}



~~~
[1] TRUE
~~~
{: .output}


~~~
1 != 2  # inequality (read as "is not equal to")
~~~
{: .language-r}



~~~
[1] TRUE
~~~
{: .output}


~~~
1 < 2  # less than
~~~
{: .language-r}



~~~
[1] TRUE
~~~
{: .output}


~~~
1 <= 1  # less than or equal to
~~~
{: .language-r}



~~~
[1] TRUE
~~~
{: .output}


~~~
1 > 0  # greater than
~~~
{: .language-r}



~~~
[1] TRUE
~~~
{: .output}


~~~
1 >= -9 # greater than or equal to
~~~
{: .language-r}



~~~
[1] TRUE
~~~
{: .output}

> ## Tip: Comparing Numbers
>
> A word of warning about comparing numbers: you should never use `==` to compare two numbers unless they are integers (a data type which can specifically represent only whole numbers).
>
> Computers may only represent decimal numbers with a certain degree of precision, so two numbers which look the same when printed out by R, may actually have different underlying representations and therefore be different by a small margin of error (called Machine numeric tolerance).
>
> Instead you should use the `all.equal` function.
>
> Further reading: <http://floating-point-gui.de/>
>
{: .callout}

## Variables and assignment

We can store values in variables using the assignment operator `<-`, like this:


~~~
x <- 1/40
~~~
{: .language-r}

Notice that assignment does not print a value. Instead, we stored it for later in something called a **variable**. `x` now contains the **value** `0.025`:


~~~
x
~~~
{: .language-r}



~~~
[1] 0.025
~~~
{: .output}

More precisely, the stored value is a *decimal approximation* of this fraction called a [floating point number](http://en.wikipedia.org/wiki/Floating_point).

Look for the `Environment` tab in the top right panel of RStudio, and you will see that `x` and its value have appeared. Our variable `x` can be used in place of a number in any calculation that expects a number:


~~~
log(x)
~~~
{: .language-r}



~~~
[1] -3.688879
~~~
{: .output}

Notice also that variables can be reassigned:


~~~
x <- 100
~~~
{: .language-r}

`x` used to contain the value 0.025 and now it has the value 100.

Assignment values can contain the variable being assigned to:


~~~
x <- x + 1 #notice how RStudio updates its description of x on the top right tab
y <- x * 2
~~~
{: .language-r}

The right hand side of the assignment can be any valid R expression. The right hand side is *fully evaluated* before the assignment occurs.

Variable names can contain letters, numbers, underscores and periods but no spaces. They must start with a letter or a period followed by a letter (they cannot start with a number nor an underscore). Variables beginning with a period are hidden variables. Different people use different conventions for long variable names, these include

-   periods.between.words
-   underscores_between_words
-   camelCaseToSeparateWords

What you use is up to you, but **be consistent**.

It is also possible to use the `=` operator for assignment:


~~~
x = 1/40
~~~
{: .language-r}

But this is much less common among R users. The most important thing is to **be consistent** with the operator you use. There are occasionally places where it is less confusing to use `<-` than `=`, and it is the most common symbol used in the community. So the recommendation is to use `<-`.

> ## Challenge 1
>
> Which of the following are valid R variable names?
>
> 
> ~~~
> min_height
> max.height
> _age
> .mass
> MaxLength
> min-length
> 2widths
> celsius2kelvin
> ~~~
> {: .language-r}
>
> > ## Solution to challenge 1
> >
> > The following can be used as R variables:
> >
> > 
> > ~~~
> > min_height
> > max.height
> > MaxLength
> > celsius2kelvin
> > ~~~
> > {: .language-r}
> >
> > The following creates a hidden variable:
> >
> > 
> > ~~~
> > .mass
> > ~~~
> > {: .language-r}
> >
> > The following will not be able to be used to create a variable
> >
> > 
> > ~~~
> > _age
> > min-length
> > 2widths
> > ~~~
> > {: .language-r}
> >
> {: .solution}
{: .challenge}

## Vectorization

One final thing to be aware of is that R is *vectorized*, meaning that variables and functions can have vectors as values. In contrast to physics and mathematics, a vector in R describes a set of values in a certain order of the same data type. For example


~~~
1:5
~~~
{: .language-r}



~~~
[1] 1 2 3 4 5
~~~
{: .output}



~~~
2^(1:5)
~~~
{: .language-r}



~~~
[1]  2  4  8 16 32
~~~
{: .output}



~~~
x <- 1:5
2^x
~~~
{: .language-r}



~~~
[1]  2  4  8 16 32
~~~
{: .output}

This is incredibly powerful; we will discuss this further in an upcoming lesson.

## Managing your environment

There are a few useful commands you can use to interact with the R session.

`ls` will list all of the variables and functions stored in the global environment (your working R session):


~~~
ls()
~~~
{: .language-r}



~~~
[1] "fix_fig_path"   "hook_error"     "hook_in"        "hook_out"      
[5] "hook_warning"   "knitr_fig_path" "x"              "y"             
~~~
{: .output}

> ## Tip: Warnings vs. Errors
>
> Pay attention when R does something unexpected! Errors, like above, are thrown when R cannot proceed with a calculation. Warnings on the other hand usually mean that the function has run, but it probably hasn't worked as expected.
>
> In both cases, the message that R prints out usually give you clues how to fix a problem.
>
{: .callout}

## R Packages

It is possible to add functions to R by writing a package, or by obtaining a package written by someone else. As of this writing, there are over 10,000 packages available on CRAN (the comprehensive R archive network). R and RStudio have functionality for managing packages:

-   You can see what packages are installed by typing `installed.packages()`
-   You can install packages by typing `install.packages("packagename")`, where `packagename` is the package name, in quotes.
-   You can update installed packages by typing `update.packages()`
-   You can remove a package with `remove.packages("packagename")`
-   You can make a package available for use with `library(packagename)`

Packages can also be viewed, loaded, and detached in the Packages tab of the lower right panel in RStudio. Clicking on this tab will display all of the installed packages with a checkbox next to them. If the box next to a package name is checked, the package is loaded and if it is empty, the package is not loaded. Click an empty box to load that package and click a checked box to detach that package.

Packages can be installed and updated from the Package tab with the Install and Update buttons at the top of the tab.

## Getting Help with R and RStudio

### RStudio contextual help

Here is one last bonus we will mention about RStudio. It's difficult to remember all of the arguments and definitions associated with a given function. When you start typing the name of a function and hit the <KBD>Tab</KBD> key, RStudio will display functions and associated help:

<img src="../fig/studio_contexthelp1.png" alt="rstudio default session" style="width: 600px;"/>

Once you type a function, hitting the <KBD>Tab</KBD> inside the parentheses will show you the function's arguments and provide additional help for each of these arguments.

<img src="../fig/studio_contexthelp2.png" alt="rstudio default session" style="width: 600px;"/>

### Reading Help files

R, and every package, provide help files for functions. The general syntax to search for help on any function, "function_name", from a specific function that is in a package loaded into your namespace (your interactive R session):


~~~
?function_name
help(function_name)
~~~
{: .language-r}

This will load up a help page in RStudio (or as plain text in R by itself).

Each help page is broken down into sections:

-   Description: An extended description of what the function does.
-   Usage: The arguments of the function and their default values.
-   Arguments: An explanation of the data each argument is expecting.
-   Details: Any important details to be aware of.
-   Value: The data the function returns.
-   See Also: Any related functions you might find useful.
-   Examples: Some examples for how to use the function.

Different functions might have different sections, but these are the main ones you should be aware of.

> ## Tip: Running Examples
>
> From within the function help page, you can highlight code in the Examples and hit <kbd>Ctrl</kbd>+<kbd>Return</kbd> to run it in RStudio console. This is gives you a quick way to get a feel for how a function works. 
{: .callout}


> ## Tip: Reading help files
>
> One of the most daunting aspects of R is the large number of functions available. It would be prohibitive, if not impossible to remember the correct usage for every function you use. Luckily, the help files mean you don't have to! 
{: .callout}

### Special Operators

To seek help on special operators, use quotes or backticks:


~~~
?"<-"
?`<-`
~~~
{: .language-r}

### Getting help on packages

Many packages come with "vignettes": tutorials and extended example documentation. Without any arguments, `vignette()` will list all vignettes for all installed packages; `vignette(package="package-name")` will list all available vignettes for `package-name`, and `vignette("vignette-name")` will open the specified vignette.

If a package doesn't have any vignettes, you can usually find help by typing `help("package-name")`.

RStudio also has a set of excellent [cheatsheets](https://rstudio.com/resources/cheatsheets/) for many packages.

### When you kind of remember the function

If you're not sure what package a function is in, or how it's specifically spelled you can do a fuzzy search:


~~~
??function_name
~~~
{: .language-r}

A fuzzy search is when you search for an approximate string match. For example, you may remember that the function to set your working directory includes "set" in its name. You can do a fuzzy search to help you identify the function:


~~~
??set
~~~
{: .language-r}

### When you have no idea where to begin

If you don't know what function or package you need to use [CRAN Task Views](http://cran.at.r-project.org/web/views) is a specially maintained list of packages grouped into fields. This can be a good starting point.

### When your code doesn't work: seeking help from your peers

First, for this course -- seek help on the relevant **Troubleshooting Board** for the week! This will allow you to get quick, extremely relevant help on your assignments and our particular data sets.

If you're having trouble using a function, 9 times out of 10, the answers you are seeking have already been answered on [Stack Overflow](http://stackoverflow.com/). You can search using the `[r]` tag. Please make sure to see their page on [how to ask a good question.](https://stackoverflow.com/help/how-to-ask)

If you can't find the answer, there are a few useful functions to help you ask a question from your peers:


~~~
?dput
~~~
{: .language-r}

Will dump the data you're working with into a format so that it can be copy and pasted by anyone else into their R session.


~~~
sessionInfo()
~~~
{: .language-r}



~~~
R version 4.1.1 (2021-08-10)
Platform: x86_64-apple-darwin17.0 (64-bit)
Running under: macOS Catalina 10.15.7

Matrix products: default
BLAS:   /Library/Frameworks/R.framework/Versions/4.1/Resources/lib/libRblas.0.dylib
LAPACK: /Library/Frameworks/R.framework/Versions/4.1/Resources/lib/libRlapack.dylib

locale:
[1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] knitr_1.36

loaded via a namespace (and not attached):
[1] compiler_4.1.1 magrittr_2.0.1 tools_4.1.1    stringi_1.7.5  stringr_1.4.0 
[6] xfun_0.28      evaluate_0.14 
~~~
{: .output}

Will print out your current version of R, as well as any packages you have loaded. This can be useful for others to help reproduce and debug your issue.



