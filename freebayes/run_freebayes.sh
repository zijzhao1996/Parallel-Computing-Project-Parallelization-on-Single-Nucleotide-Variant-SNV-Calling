#! /bin/bash
# this function takes 2 extra arguments:
# 1. region, (20:1000000-2000000)
# 2. read length, (100)
#echo "Processing region: $1"
NEWREGION=$( echo "$1 $2" | awk 'function max(a, b) {
    return a > b ? a: b
}
{split($0,a,":|-| ");
printf "%s:%s-%s\n", a[1], max(a[2]-a[4],0), a[3]+a[4]}')
#echo "Get alignment from region: $NEWREGION"

# run samtools + frebayes
samtools view -h /home/freebayes/data/NA21141.chrom20.ILLUMINA.bwa.GIH.low_coverage.20130415.bam "$NEWREGION" \
| freebayes -f /home/freebayes/data/chr20.fa -c #-v /home/freebayes/data/results/NA21141_$1.vcf
