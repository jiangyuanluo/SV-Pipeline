#!/bin/bash

input=$1
outdir=$2
filename=$(basename $input)
dir='/home/jluo/breakdancer'
toolName="BreakDancer(v1.4.5)"
mkdir $outdir

# -----------------------------------------------

now="$(date)"

logfile=${outdir}/report_breakdancer_v1.4.5.${filename}.log

printf "START\n" >> $logfile
printf "%s --- RUNNING %s\n" "$now" $toolName >> $logfile

res1=$(date +%s.%N)

cfg=${outdir}/${filename}.cfg
call=${outdir}/${filename}.calls
vcf=${outdir}/${filename}.vcf

perl $dir/perl/bam2cfg.pl $input > $cfg
$dir/build/bin/breakdancer-max $cfg > $call
python $dir/tools/generateVCF.py $call

res2=$(date +%s.%N)
dt=$(echo "$res2-$res1" | bc)
dd=$(echo "$dt/86400" | bc)
dt2=$(echo "$dt-86400*$dd" | bc)
dh=$(echo "$dt2/3600" | bc)
dt3=$(echo "$dt2-3600*$dh" | bc)
dm=$(echo "$dt3/60" | bc)
ds=$(echo "$dt3-60*$dm" | bc)
now="$(date)"
printf "%s --- TOTAL RUNTIME: %d:%02d:%02d:%02.4f\n" "$now" $dd $dh $dm $ds >> $logfile

now="$(date)"
printf "%s --- FINISHED RUNNING %s %s\n" "$now" "$toolName" >> $logfile

# -----------------------------------------------

printf "DONE\n" >> $logfile
