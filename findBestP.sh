#!/bin/bash

excludeP=rc_admin

while getopts o:f: option
do
case "${option}"
in
o) optU=${OPTARG};;
f) optF=${OPTARG};;
esac
done

if [[ $optU = help ]]; then
  echo "   --- Find and print Slurm configuration: sh findBestP.sh -f submit.sh -o set"
  echo "   --- Check for the best Slurm partition: sh findBestP.sh -f submit.sh -o check"
fi

submissionScript=$optF

if [[ $optU = set ]]; then

  if [[ ! $optF ]]; then
    echo "   --- Specify Slurm submission script with the -f option."
    exit 1
  fi

  rm -rf tmpwdir
  mkdir -p tmpwdir

  # Dump Slurm partitions and their allowed groups to a file
  scontrol show partition | grep "PartitionName\|AllowGroups" > tmpwdir/slurmPartInfo.txt

  # Get total number of Slurm patitions.
  numPar=$(scontrol show partition | grep "PartitionName" | wc -l)

  # Re-count number of Slurm partitions
  nL=$(cat tmpwdir/slurmPartInfo.txt | wc -l)

  # Throw an error if there is a mismatch in number of Slurm patitions
  if [ $((nL/2)) -ne $numPar ]; then
    echo "   --- There is error with number of SLURM partitions."
    echo "   --- Number of actual partitions:  $numPar"
    echo "   --- Number of partitions in the file:  $((nL/2))"
  fi

  # Number of groups associated with user
  grps=$(groups)
  nGrp=$(echo $grps | wc -w)
  rm -f tmpwdir/allowedParts.txt

  # Loop over SLURM partitions
  for i in $(seq 2 2 $nL); do
    sw=$(head -$i tmpwdir/slurmPartInfo.txt | tail -2)
    parName=$(echo $sw | cut -d'=' -f2 | cut -d' ' -f1)

    for j in $(seq 1 $nGrp); do
      grpN=$(echo $grps | cut -d' ' -f$j)
      if [ $grpN != $excludeP ]; then
        if [[ $sw = *"$grpN"* ]]; then
          #echo "   --- Group: $grpN, Partition: $parName"
          echo $parName >> tmpwdir/allowedParts.txt
        fi
      fi
    done
  done

fi


if [[ $optU = check ]]; then

  if [[ ! $optF ]]; then
    echo "   --- Specify Slurm submission script with the -f option."
    exit 1
  fi

  if [ ! -e tmpwdir/allowedParts.txt ]; then
    echo "   --- Error: allowedParts.txt file is not there. Running: sh findBestP.sh -f $submissionScript -o set"
    sh findBestP.sh -f $submissionScript -o set
  fi

  # Check specific Slurm submission line number for partition name
  lineN=$(grep -n " -p "  $submissionScript | cut -d':' -f1)

  if [ ! $lineN ]; then
    lineN=$(grep -n " --partition "  $submissionScript | cut -d':' -f1)
    if [ ! $lineN ]; then
      echo "   --- Error: Specifiy a default partition in Slurm submission script."
      exit 1
    fi
  fi

  rm -f tmpwdir/result.txt
  echo " "

  # Loop over each allowed Slurm partition listed in allowedParts.txt file
  for i in $(cat tmpwdir/allowedParts.txt); do
    # Change the partition name
    subSName=tmpwdir/slurm_$i.sh
    sed "${lineN}s/.*/#SBATCH -p $i/" $submissionScript > $subSName

    tmpF=${subSName/.sh}_tmp.txt

    # run sbatch with --test-only to get time
    sbatch --test-only $subSName > $tmpF 2>&1

    if [[ $(cat $tmpF) = *"error"* ]]; then
      echo "   --- Error in using partition: $i"
      continue
    fi

    swT=$(cat $tmpF | cut -d' ' -f7)
    swT=${swT/T/" "}
    timCurrent=$(date +%s)
    timEp=$(date -d "$swT" +%s 2>/dev/null)
    timeDiff=$(($timEp-$timCurrent))

    if [[ $timeDiff -lt 0 ]]; then
      echo "   --- Error in using partition: $i"
      continue
    fi

    echo "   --- $timeDiff seconds on: $i" >> tmpwdir/result.txt
  done

  echo " "
  echo "   --- Results sorted by time (sec)"
  sort -k2 -n tmpwdir/result.txt
fi
