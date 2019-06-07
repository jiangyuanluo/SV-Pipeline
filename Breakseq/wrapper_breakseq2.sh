#!/bin/bash

. /u/local/Modules/default/init/modules.sh
module load samtools
module load python/2.7

input=$1
outdir=$2
reference=$3
filename=$(basename $input)
dir='/u/home/j/jiangyua/breakseq2-2.2'
toolName="BreakSeq(v2.2)"
mkdir $outdir

# -----------------------------------------------

now="$(date)"

logfile=${outdir}/report_breakseq_v2.2.${filename}.log

printf "START\n" >> $logfile
printf "%s --- RUNNING %s\n" "$now" $toolName >> $logfile

res1=$(date +%s.%N)

work=${outdir}/${filename}
vcf=${outdir}/${filename}/${filename}.vcf

python $dir/scripts/run_breakseq2.py --reference $reference --bams $input --work $work --bwa /u/local/apps/bwa/0.7.17/gcc-4.4.7/bwa --samtools /u/local/apps/samtools/0.1.19/gcc-4.4.7/samtools --bplib /u/home/j/jiangyua/breakseq2_bplib_20150129.hg37/breakseq2_bplib_20150129.fna

gunzip $work/breakseq.vcf.gz

mv $work/breakseq.vcf $vcf

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
