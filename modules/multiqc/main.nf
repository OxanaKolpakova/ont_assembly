process MULTIQC {
    publishDir 'results/MULTIQC'
    tag 'all_samples'
    conda 'bioconda::multiqc'
    input:
    path files

    output:
    path '*.html', emit: html
    
    script:
    """
    multiqc . 
    """
}