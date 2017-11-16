#!/usr/bin/env bash
#Input 1 is input JSON file (from list-jobs)

grep "jobId" $1 > jobids.tmp
sed s/\"//g jobids.tmp | sed s/jobId//g | sed s/://g | sed s/' '//g > cleanedjobids.tmp

while read job
do
    aws batch cancel-job --job-id $job --reason "memory" --profile lab --region us-east-1
    echo "Deleted job $job"
done < cleanedjobids.tmp

