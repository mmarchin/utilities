
dir = commandArgs(trailingOnly=TRUE);

d<-read.table(paste(dir,"/","chrom_count.txt",sep=''),as.is=T,header=F)
df<-data.frame(d[,2],d[,1])
colnames(df)<-c("chrom","counts")

spikes<-c("LYS","PHE","THR","TRP","DAP")
spikes.iv<-match(spikes,df[,1])

pdf(paste(dir,"/spikes.pdf",sep=''))
barplot(log10(df[spikes.iv,2]),names.arg=df[spikes.iv,1],ylab="log10(count)",main="Spike-ins")

write.table(df[spikes.iv,],paste(dir,"/spike_counts.txt",sep=''),row.names=F,quote=F,sep='\t')

genes.expr<-read.table(paste(dir,"/cufflinksG/genes.expr",sep=''),as.is=T,sep='\t',quote='',header=T)
spikes2.iv<-match(spikes,genes.expr[,1])

hist(log2(genes.expr[,6]),breaks=100,main="cufflinks log2(RPKM) distribution",xlab="log2(RPKM)")
rug(log2(genes.expr[spikes2.iv,6]),col='red')
text(log2(genes.expr[spikes2.iv,6]),-20,spikes,col='black',cex=.5)
dev.off()

