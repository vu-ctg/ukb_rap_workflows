#!/bin/bash
# merge plink result files across chromosomes

# Set environmental variables
## Files to merge should have the format c[chromosome#]_*[basename].[extension]
## e.g., c22_gestationaldiabetes_EUR.glm.logistic

outputdir= #put in the directory in user's project where output files to merge are located (exclude leading "/")
	## This should be the same project where this script is being run
basename= #put in the base name of the files to merge, excluding chr and final extension (e.g., gestationaldiabetes_EUR.glm)
extension= #put in the filetype extension of the files you want to merge (e.g., linear, logistic, hybrid, freq). 
mergedfile=merged_${basename}.${extension} #change merged file name if desired


# Check that the correct (per chromosome) result files exist and download to job directory

dx ls ${outputdir}/c*_${basename}.${extension}
NR_OF_RESULTFILES=`dx ls ${outputdir}/c*_${basename}.${extension} | wc -l`

if [[ "${NR_OF_RESULTFILES}" != "24" ]]; then
  echo "WARNING: Nr of result files (${NR_OF_RESULTFILES}) does not equal number of input chunks (24)!"
  echo "If you did not filter SNPs (e.g. by chromosome) this may indicate failed analyses that need to be re-run."
  echo "Do you want to continue merging the existing result files anyway? [y/N]"
  read ANSWER
  if [[ "${ANSWER}" == "y" ]]; then
    echo "Continue merge..."
  else
    echo "Merge aborted."
    exit -1
  fi
else
  echo "Nr of result files equals number of input chunks ${NR_OF_RESULTFILES}: OK"
fi

dx download ${outputdir}/c*_${basename}.${extension}



# Merge files across chromosomes

FIRST_FILE=`ls c*_${basename}.${extension} | head -n 1 -q`
head -n1 ${FIRST_FILE} > ${mergedfile}.temp

for i in {1..22} X XY; do
   if [ -f "c${i}_${basename}.${extension}" ]; then
      tail -n+2 -q c${i}_${basename}.${extension} >> ${mergedfile}.temp
   fi
done



#  Reduce the columns to the essentials needed for downstream analyses and rename the columns for compatibility with other software 
### (output columns: SNP, CHR, BP, A1 [effect allele], A2, EAF, N, BETA/OR, SE, P, [Ncase, Ncontrol, Neff]) - adjust as needed.
### double check that the desired columns are correctly selected here, especially if you used different analysis settings!

# Linear regression results
if [[ "${extension}" == "linear" ]]; then
    awk '{print $3"\t"$1"\t"$2"\t"$7"\t"$8"\t"$9"\t"$11"\t"$12"\t"$13"\t"$15 }' ${mergedfile}.temp > ${mergedfile}
    sed -i "1d" ${mergedfile}
    sed -i "1i SNP\tCHR\tBP\tA1\tA2\tEAF\tN\tBETA\tSE\tP" ${mergedfile}
fi

# Logistic/hybrid regression results - use this option if --glm cols=+totallelecc option was applied
## (i.e. results file has case/control allele counts for calculating Ncase/Ncontrol/Neff (effective sample size))
if [[ "${extension}" == "logistic" ]] || [[ "${extension}" == "hybrid" ]]; then
    awk '{print $3"\t"$1"\t"$2"\t"$7"\t"$8"\t"$11"\t"$15"\t"$16"\t"$18"\t"($9/2)"\t"($10/2)"\t"4/((1/($9/2))+(1/($10/2))) }' ${mergedfile}.temp > ${mergedfile}
    sed -i "1d" ${mergedfile}
    sed -i "1i SNP\tCHR\tBP\tA1\tA2\tEAF\tOR\tSE\tP\tNcase\tNcontrol\tNeff" ${mergedfile}
fi

# Logistic/hybrid regression - use this option if no case/control allele counts were included in results file
#if [[ "${extension}" == "logistic" ]] || [[ "${extension}" == "hybrid" ]]; then
#    awk '{print $3"\t"$1"\t"$2"\t"$7"\t"$8"\t"$9"\t"$12"\t"$13"\t"$14"\t"$16 }' ${mergedfile}.temp > ${mergedfile}
#    sed -i "1d" ${mergedfile}
#    sed -i "1i SNP\tCHR\tBP\tA1\tA2\tEAF\tN\tOR\tSE\tP" ${mergedfile}
#fi


# Re-upload files to user's directory

dx upload ${mergedfile} --path ${outputdir}

echo "Merged snptest results file save to: ${outputdir}/${mergedfile}"
echo "Nr of lines in saved file:"
wc -l ${mergedfile}




