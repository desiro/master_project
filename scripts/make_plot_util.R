#!/usr/bin/Rscript
## utility function script for make_plot.R

library(ggplot2)
library(RColorBrewer)




###############################################################################
## make name list
###############################################################################

makeNameList <- function (gold.name) {
    
    file.list <- vector('list', length(assembler.names))
    names(file.list) <- assembler.names
    for (assembler in assembler.names) {
        file.list[[assembler]] <- vector('list', length(kmer.names))
        names(file.list[[assembler]]) <- kmer.names
        for (kmer in kmer.names) {
            file.list[[assembler]][[kmer]] <- paste(paste('S7_dc-megablast', assembler, gold.name, kmer, 'count', sep='_'), 'cnt', sep='.')
        }
    }
    file.list[[length(file.list)+1]] <- vector('list', 2)
    names(file.list) <- c('MetaVelvet', 'Ray Meta', 'IDBA-UD', 'BLAST')
    names(file.list[['BLAST']]) <- c('Mega','DC-M')
    file.list[['BLAST']][['Mega']] <- paste(paste('S7_megablast', gold.name, 'count', sep='_'), 'cnt', sep='.')
    file.list[['BLAST']][['DC-M']] <- paste(paste('S7_dc-megablast', gold.name, 'count', sep='_'), 'cnt', sep='.')
    return(file.list)
}


###############################################################################
## read count files
###############################################################################

readCounts <- function (count.file) {
    
    column.setting = c('character', 'NULL', 'numeric', 'numeric', 'numeric')
    input.frame <- read.table(file.path(data.dir, count.file), header=FALSE, colClasses=column.setting)
    names(input.frame) <- c('tax', 'richtig', 'falsch', 'unbekannt')
    return(input.frame)
}


###############################################################################
## sum counts
###############################################################################

sumCounts <- function (count.frame) {
    
    count.vector <- vector('numeric', 3)
    names(count.vector) <- c('richtig', 'falsch', 'unbekannt')
    for (type in names(count.vector)) {
        count.vector[[type]] <- sum(count.frame[[type]])
    }
    return(count.vector)
}


###############################################################################
## make plot frame
###############################################################################

makePlotFrame <- function (count.list) {
    
    assembler.group <- unlist(lapply(names(count.list), function (x) return(rep(x, length(count.list[[x]])*3))))
    kmer.group <- unlist(lapply(count.list, function(x) return(lapply(names(x), function(y) return(rep(y,3))))))
    type.group <- c('richtig', 'falsch', 'unbekannt')
    item.group <- unlist(count.list)
    plot.frame <- data.frame(assembler.group, kmer.group, type.group, item.group)
    return(plot.frame)
}


###############################################################################
## make plot
###############################################################################

makeBarPlot <- function (count.frame, pdf.file.name) {
    
    p <- ggplot(data=count.frame, aes(kmer.group, fill=type.group)) +
            geom_bar(stat='identity', aes(y=item.group), position='dodge') +
            scale_fill_manual(guide=FALSE, name='', values=c('red3', 'green4','grey60')) +
            xlab('k-mer') + ylab('reads') +
            facet_grid(. ~ assembler.group, scale='free_x', space='free_x') #+
            #theme(plot.margin=margin(10,10,40,10), legend.position=c(0.5, -0.24), legend.direction='horizontal') # top, right, bottom, left
    print(p)
    
    ggsave(file.path(main.dir, pdf.file.name), width=24, height=10, scale=1.0, units='cm')
    message('File \'', pdf.file.name, '\' created ...')
}


###############################################################################
## write ratio table
###############################################################################

writeRatioTable <- function (count.list, table.file.name) {
    
    ratio.matrix <- matrix(nrow=length(count.list), ncol=18)
    for (i in 1:length(count.list)) {
        for (j in 1:length(count.list[[i]])) {
            total <- sum(count.list[[i]][[j]])
            ratio.matrix[i,j+0] <- count.list[[i]][[j]][['richtig']]/total
            ratio.matrix[i,j+6] <- count.list[[i]][[j]][['falsch']]/total
            ratio.matrix[i,j+12] <- count.list[[i]][[j]][['unbekannt']]/total
        }
    }
    colnames(ratio.matrix) <- c(paste(kmer.names, 'richtig'), paste(kmer.names, 'falsch'), paste(kmer.names, 'unbekannt'))
    rownames(ratio.matrix) <- names(count.list)
    write.table(round(ratio.matrix,4), file.path(main.dir, table.file.name), row.names=TRUE, col.names=TRUE, sep='\t', quote=FALSE)
    message('File \'', table.file.name, '\' with data values created ...')
}






















