process FASTQC {
    publishDir 'results/FASTQC'
    tag "$sid"
    conda 'bioconda::fastqc'
    container 'staphb/fastqc:latest'
    cpus params.cpus
        
    input:
    tuple val(sid), path(reads)

    output:
    tuple val(sid), path('*.zip'), emit: zip
    tuple val(sid), path('*.html'), emit: html
    
    script:
    """
    fastqc $reads -t ${task.cpus}
    """
}