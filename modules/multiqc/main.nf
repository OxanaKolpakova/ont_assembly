process MULTIQC {
    publishDir 'results/MULTIQC'
    tag 'all_samples'
    conda "${moduleDir}/environment.yml"
    container 'staphb/multiqc:latest'
    input:
    path files

    output:
    path '*.html', emit: html
    
    script:
    """
    multiqc . 
    """
}