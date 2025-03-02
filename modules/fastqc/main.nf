process FASTQC {
    publishDir 'results/FASTQC'
    tag "$reads"
    conda 'bioconda::fastqc'
    container 'staphb/fastqc:latest'
    
    input:
    tuple val(sid), path(reads)

    output:
    tuple val(sid), path('*.zip'), emit: zip
    tuple val(sid), path('*.html'), emit: html
    
    script:
    """
    fastqc $reads -t 2
    """
}