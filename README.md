# SpliTWAS

SpliTWAS is framework that associates the genetically driven complexity of alternative RNA processing to disease. 

SpliTWAS examines alternative splicing patterns to identify splicing-trait associations which are then fine-mapped at both the gene and exon levels. The degree of alternative splicing of an exon is quantified through percent spliced in (PSI), which indicates the level of exon inclusion in the transcriptpopulation of a gene, allowing an exon-centric view of the transcriptome. 

The SpliTWAS framework is based on the work of Gusev et al. “[Integrative approaches for large-scale transcriptome-wide association studies](https://www.ncbi.nlm.nih.gov/pubmed/26854917)” 2016 Nature Genetics, with modifications described in our publication. Similarly to the FUSION/TWAS framework, the user can decide wether to compute their own predictive models for splicing based on an RNA-seq panel paired with genotype data or use precomputed models from BrainGVEX and CommonMind datasets availabile at [Models](https://www.ncbi.nlm.nih.gov/pubmed/26854917).



### Installation of FUSION 

SpliTWAS is based on the FUSION framework, we recommend following the installation described in [FUSION]([url](http://gusevlab.org/projects/fusion/)), as it covers the dependencies, required packages, external software and a thorough description of the workflow in the original framework.

### PSI Calculation

For the computation of your own predictive models we start by first quantifying PSI. Otherwise, if using the pre-computed weights made available at the link above skip to the association step.

PSI is calculated using the set of scripts and annotations described in: [PSI_Calculator](https://github.com/gxiaolab/PSI_calculator). The scripts and annotations will yield PSI quantification for exonic parts, and these will be referenced as exons from here onwards.

### PSI matrix clean-up and S-value transformation

Utilizing the PSI_matrix_clean_up.py script we can feed our PSI matrix compromised of exons x samples, to remove exons with little to no variance `sd < 0.005`, missing in over 60% of samples, and impute values for those with over 40% coverage. 

Additionally the script will transform the matrix from PSI values to S-Values with the following formula  $` S-Value = log2(PSI/1+alpha-PSI) `$

### SpliTWAS predictive models

After installation of 

