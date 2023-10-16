#!/bin/bash


#Location of required software
FUSION="./FUSION.compute_weights_Jon.R"
GCTA="path/to/GCTA"
GEMMA="/path/to/gemma-0.98.5"
LDREF="/path/to/LDREF"
PLINK="/path/to/PLINK"

#Specify Directories and data locations

DATA_DIR="./Data/"
OUT_DIR="WEIGHT_DIR"
RUN_DIR="../Scripts/"

GENO="path/to/genotypes/"
IDS="path/to/ID_file"
PRE_GEXP="S_Value_Matrix_BGVEX.tsv"
# Specify usage limits for PLINK
MEM=4000
N_THREADS=1

# Rows in the matrix to analyze
BATCH_START=$1
BATCH_END=$2


# -- Begin Analysis -- #

start_time=$SECONDS
NR="${BATCH_START}_${BATCH_END}"

TMPDIR="/Temp/$NR"

# remove if exists, otherwise create
    if [ -d $TMPDIR ]; then
        rm -f -r $TMPDIR
    fi
    mkdir -p $TMPDIR

# Loop through each gene expression phenotype in the batch
cat $PRE_GEXP | awk -vs=$BATCH_START -ve=$BATCH_END 'NR > s && NR <= e' |  while read PARAM; do

# Get the exon positions +/- 10kb
CHR=`echo $PARAM | awk '{gsub("chr","") ; print $3 }'`
P0=`echo $PARAM | awk '{ print $4 - 0.01e6 }'`
P1=`echo $PARAM | awk '{ print $5 + 0.01e6 }'`
GNAME=`echo $PARAM | awk '{ print $1 }'`
echo $GNAME $CHR $P0 $P1

# Define temporary outfile names
cd $TMPDIR
ln -s ./ output

OUT=$TMPDIR/${GNAME}

# Create phenotype file for plink
echo $PARAM | tr ' ' '\n' | tail -n+6 | paste $IDS - > $OUT.pheno

# Remove file if it exists
rm -f $OUT.bed

# Get the locus genotypes for all samples and set current S-Value as the phenotype
$PLINK --bfile $GENO$CHR --pheno $OUT.pheno --make-bed --out $OUT --allow-no-sex --snps-only --keep $OUT.pheno --maf 0.05 --chr $CHR --from-bp $P0 --to-bp $P1 --threads $N_THREADS --memory $MEM --extract $LDREF/1000G.EUR.$CHR.bim 

# Define output name
mkdir -p $OUT_DIR/ALL
FINAL_OUT="$OUT_DIR/ALL/ALL.$GNAME"

# Compute weights and specify models to be computed
Rscript $FUSION --bfile $OUT --tmp TEMP --out $FINAL_OUT --verbose 0 --save_hsq --PATH_gcta $GCTA --PATH_gemma $GEMMA --PATH_plink $PLINK --hsq_p 1.00 --models lasso,top1,enet,blup


# Clean-up
rm -f $FINAL_OUT.hsq $OUT.tmp.*
rm $OUT.*
done


# Move back up to run directory, clean up temporary directory
#cd $RUN_DIR
rm -f -r $TMPDIR