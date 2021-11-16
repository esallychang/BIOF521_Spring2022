# Load packages -----------------------------------------------------------

suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
  library(ggrepel)
})


# Import data  ------------------------------------------------------------

results <- read.csv("limma-voom_basalpregnant-basallactate.csv")


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
# colours <- setNames(c("cornflowerblue", "grey", "firebrick"), c(down, notsig, up))
colours <- setNames(c("purple", "grey", "orange"), c(down, notsig, up))

# Create significant (sig) column
results <- mutate(results, sig = case_when(
  fdr < 0.01 & logfc > 0.58 ~ up,
  fdr < 0.01 & logfc < -0.58 ~ down,
  TRUE ~ notsig))


# Specify genes to label --------------------------------------------------

# Get top genes by P value
top <- slice_min(results, order_by = pvalue, n = 20)

# Extract into vector
toplabels <- pull(top, labels)

# Label just the top genes in results table
results <- mutate(results, labels = ifelse(labels %in% toplabels, labels, ""))


# Create plot -------------------------------------------------------------

# Set up base plot
p <- ggplot(data = results, aes(x = logfc, y = -log10(pvalue))) +
  geom_point(aes(colour = sig), size = 0.5, alpha=0.5) +
  scale_color_manual(values = colours) +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = "black"),
        legend.key = element_blank())

# Add gene labels
p <- p + geom_text_repel(data = filter(results, labels != ""), aes(label = labels), size = 3,
                         min.segment.length = 0,
                         max.overlaps = Inf,
                         show.legend = FALSE)






# Set legend title
p <- p + labs(title="Informative Title")

# Print plot
print(p)


# R and Package versions -------------------------------------------------
sessionInfo()
