#!/usr/bin/Rscript
## script for generating bar plots and ratio tables

library(ggplot2)
library(RColorBrewer)




###############################################################################
## set directories and get arguments
###############################################################################

main.dir <- 'D:/uni/work/m_project/gold_final/final'
data.dir <- 'D:/uni/work/m_project/gold_final/data'
assembler.names <- c('metaVelvet', 'rayMeta', 'idba-ud')
blast.names <- c('dc-megablast', 'megablast')
gold.names <- c('gold10', 'gold100', 'gold1000')
kmer.names <- c('31', '43', '55', '67', '79', '91')

source(file.path(main.dir, 'make_plot_util.R'))


###############################################################################
## do for each goldstandard
###############################################################################

for (gold.file in gold.names) {
    
    ## set input files
    file.list <- makeNameList(gold.file)
    
    ## load count files
    raw.count.list <- lapply(file.list, function(x) return(lapply(x, readCounts)))
    
    ## summarize countsl
    sum.count.list <- lapply(raw.count.list, function(x) return(lapply(x, sumCounts)))
    
    ## make plot frame
    plot.frame <- makePlotFrame(sum.count.list)
    
    ## make bar plot
    makeBarPlot(plot.frame, paste(paste(gold.file, 'BarPlot', sep='_'), 'pdf', sep='.'))
    
    ## make ratio table
    writeRatioTable(sum.count.list, paste(paste(gold.file, 'RatioTable', sep='_'), 'txt', sep='.'))
    
}
