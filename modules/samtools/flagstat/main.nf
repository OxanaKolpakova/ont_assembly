process SAMTOOLS_FLAGSTAT {
    publishDir 'results/SAMTOOLS_FLAGSTAT'
    tag "$sid"
    conda 'bioconda::samtools'
    container 'glebusasha/bwa_samtools:latest'
    errorStrategy 'ignore'
    cpus params.cpus
       
    input:
    tuple val(sid), path(bam), path(bam_bai) 
       
    output:
    tuple val(sid), path("${sid}.flagstat")
    
    script:
    """
    samtools flagstat -@ ${task.cpus} $bam > ${sid}.flagstat
    """
}