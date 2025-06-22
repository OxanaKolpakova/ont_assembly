process SAMTOOLS_INDEX {
    tag "$sid"
    conda 'bioconda::samtools'
    container 'glebusasha/bwa_samtools:latest'
    errorStrategy 'ignore'
       
    input:
    tuple val(sid), path(bam) 
       
    output:
    tuple val(sid), path("${bam.simpleName}.bam.bai")
    
    script:
    """
    samtools index $bam
    """
}