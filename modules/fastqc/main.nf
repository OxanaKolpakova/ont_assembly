process FASTQC {
    publishDir 'results/FASTQC'
    tag "$reads"
    conda 'bioconda::fastqc'
    input:
    path reads

    output:
    path '*.zip', emit: zip
    path '*.html', emit: html
    
    script:
    """
    fastqc $reads -t 2
    """
}