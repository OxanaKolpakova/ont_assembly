process DORADO {
    container 'staphb/dorado:0.8.3'
//	  debug true
//    errorStrategy 'ignore'
    cpus params.cpus 

    input:
    path pod5
    path dorado_models

    output:
    path '*'

    script:
    """
    dorado basecaller $dorado_models $pod5 \
        --emit-fastq \
        --recursive \
        --device auto \
        --output-dir dorado_out        
    """

    stub:
    """
    
    """
}