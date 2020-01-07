#!/bin/bash

if [ $# -lt 2 ];
then
    echo "usage: $0 [regions file] [ncpus] [GNU parallel arguments]"
    echo
    echo "Run freebayes in parallel over regions listed in regions file, using ncpus processors."
    echo "Will merge and sort output, producing a uniform VCF stream on stdout.  Flags to freebayes"
    echo "which would write to e.g. a particular file will obviously cause problms, so caution is"
    echo "encouraged when using this script."
    echo "For now the input file is hard coded inside of it, just for testing purposes"
    echo
    exit
fi

regionsfile=$1
shift
ncpus=$1
shift

(
#$command | head -100 | grep "^#" # generate header
# iterate over regions using gnu parallel to dispatch jobs
cat "$regionsfile" | parallel -k -j "$ncpus" \
"$@" "/home/freebayes/data/run_freebayes.sh" {} 100 
) | /home/ubuntu/freebayes/vcflib/scripts/vcffirstheader \
    | /home/ubuntu/freebayes/vcflib/bin/vcfstreamsort -w 1000 | /home/ubuntu/freebayes/vcflib/bin/vcfuniq # remove duplicates at region edges
