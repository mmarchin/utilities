args<-commandArgs()[4:length(commandArgs())];
numchrom<-args[1]
numsamples<-args[2]
lengths = args[3:length(args)]
res<-sample(1:numchrom,numsamples,replace=T,prob=lengths)-1;
cat(res);
