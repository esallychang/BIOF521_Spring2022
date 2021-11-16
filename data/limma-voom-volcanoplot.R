
# Galaxy settings start ---------------------------------------------------

# setup R error handling to go to stderr
options(show.error.messages = F, error = function() {cat(geterrmessage(), file = stderr()); q("no", 1, F)})

# we need that to not crash galaxy with an UTF8 error on German LC settings.
loc <- Sys.setlocale("LC_MESSAGES", "en_US.UTF-8")

# Galaxy settings end -----------------------------------------------------

# Load packages -----------------------------------------------------------

suppressPackageStartupMessages({
    library(dplyr)
    library(ggplot2)
    library(ggrepel)
})


# Import data  ------------------------------------------------------------

results <- read.delim('/corral4/main/objects/5/e/5/dataset_5e5c4768-8786-4265-8fb1-f1abb8054662.dat', header = TRUE)


# Format data  ------------------------------------------------------------

# Create columns from the column numbers specified
results <- results %>% mutate(fdr = .[[8]],
                              pvalue = .[[7]],
                              logfc = .[[4]],
                              labels = .[[2]])

# Get names for legend
down <- unlist(strsplit('Down,Not Sig,Up', split = ","))[1]
notsig <- unlist(strsplit('Down,Not Sig,Up', split = ","))[2]
up <- unlist(strsplit('Down,Not Sig,Up', split = ","))[3]

# Set colours
colours <- setNames(c("cornflowerblue", "grey", "firebrick"), c(down, notsig, up))

# Create significant (sig) column
results <- mutate(results, sig = case_when(
                                fdr < 0.01 & logfc > 0.58 ~ up,
                                fdr < 0.01 & logfc < -0.58 ~ down,
                                TRUE ~ notsig))


# Specify genes to label --------------------------------------------------

# Get top genes by P value
top <- slice_min(results, order_by = pvalue, n = 10)

# Extract into vector
toplabels <- pull(top, labels)

# Label just the top genes in results table
results <- mutate(results, labels = ifelse(labels %in% toplabels, labels, ""))


# Create plot -------------------------------------------------------------


# Set up base plot
p <- ggplot(data = results, aes(x = logfc, y = -log10(pvalue))) +
    geom_point(aes(colour = sig)) +
    scale_color_manual(values = colours) +
    theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = "black"),
        legend.key = element_blank())

# Add gene labels
p <- p + geom_text_repel(data = filter(results, labels != ""), aes(label = labels),
                         min.segment.length = 0,
                         max.overlaps = Inf,
                         show.legend = FALSE)






# Set legend title
p <- p + theme(legend.title = element_blank())

# Print plot
print(p)


# R and Package versions -------------------------------------------------
sessionInfo()

