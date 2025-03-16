process SAMTOOLS_INDEX {
    publishDir 'results/SAMTOOLS_INDEX'
    tag "$sid"
    conda 'bioconda::samtools'
    container 'glebusasha/bwa_samtools:latest'
    //errorStrategy 'ignore'
       
    input:
    tuple val(sid), path(bam) 
       
    output:
    tuple val(sid), path("${sid}.bam.bai")
    
    script:
    """
    samtools index $bam
    """
}