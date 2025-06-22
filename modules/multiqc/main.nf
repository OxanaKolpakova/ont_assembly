process MULTIQC {
    tag 'all_samples'
    //conda "${moduleDir}/environment.yml"
    //container 'staphb/multiqc:latest'
    input:
    path files

    output:
    path '*.html', emit: html
    
    script:
    """
    multiqc . -c ${moduleDir}/multiqc_config.yaml
    """
}