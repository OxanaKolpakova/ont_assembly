process SAMTOOLS_SORT {
    publishDir 'results/SAMTOOLS_SORT'
    tag "$sid"
    conda 'bioconda::samtools'
    container 'glebusasha/bwa_samtools:latest'
    errorStrategy 'ignore'
       
    input:
    tuple val(sid), path(bam) 
       
    output:
    tuple val(sid), path("${sid}_sorted.bam")
    
    script:
    """
    samtools sort -o ${sid}_sorted.bam $bam 
    """
}