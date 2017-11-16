#!/usr/bin/env bash
#Resubmit all failed jobs from a job queue
#Input 1 is correlation suffix
#Input 2 is Input column number
#Input 3 is Output column number
#Input 4 is # of CPUs to allocate
#Input 5 is job queue

echo "Input column: $2"
INPUT=$(cut -f2 -d' ' CORM_columns.txt | head -n $2 | tail -n 1)
echo "Input: $INPUT"

echo "Output column $3"
OUTPUT=$(cut -f2 -d' ' CORM_columns.txt | head -n $3 | tail -n 1)
echo "Output: $OUTPUT"

string=$INPUT$OUTPUT

aws batch list-jobs --job-queue $5 --job-status FAILED --profile lab --region us-east-2 > failedjobs.tmp

grep "jobName" failedjobs.tmp > jobids.tmp
sed s/\"//g jobids.tmp | sed s/jobName//g | sed s/://g | sed s/' '//g | sed s/$string//g | sed s/,//g > cleanedjobnums.tmp

while read job
do
    sed s/INPUTCOL/$2/ < template.json | sed s/OUTPUTCOL/$3/ | sed s/PARAM/$job/ | sed s/CORR/$1/ | sed s/CPU/$4/ > temp.json
    aws batch submit-job --profile lab --region us-east-2 --job-name $INPUT$OUTPUT$job --job-queue $5 \
    --cli-input-json file://temp.json
    echo "Submitted job $job."
done < cleanedjobnums.tmp

