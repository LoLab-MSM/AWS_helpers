#!/usr/bin/env bash
#Input 1 is correlation suffix
#Input 2 is Input column number
#Input 3 is Output column number
#Input 4 is Starting parameter
#Input 5 is Ending parameter
#Input 6 is # of CPUs to allocate

echo "Input column: $2"
INPUT=$(cut -f2 -d' ' CORM_columns.txt | head -n $2 | tail -n 1)
echo "Input: $INPUT"

echo "Output column $3"
OUTPUT=$(cut -f2 -d' ' CORM_columns.txt | head -n $3 | tail -n 1)
echo "Output: $OUTPUT"

echo $INPUT$OUTPUT$1

for (( i=$4; i<=$5; i++ ))
do
    sed s/INPUTCOL/$2/ < template.json | sed s/OUTPUTCOL/$3/ | sed s/PARAM/$i/ | sed s/CORR/$1/ | sed s/CPU/$6/ > temp.json
    aws batch submit-job --profile lab --region us-east-2 --job-name $INPUT$OUTPUT$i --job-queue mutualinformation_2CPUs \
    --cli-input-json file://temp.json
    echo "Submitted job $i."
    #aws batch submit-job --job-name example --job-queue HighPriority  --job-definition sleep60 --generate-cli-skeleton output --profile lab --region us-east-1
done