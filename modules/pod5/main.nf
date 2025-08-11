process POD5 {
    container 'staphb/pod5:0.3.27'
//	  debug true
//    errorStrategy 'ignore'
    cpus params.cpus 

    input:
    path fast5

    output:
    path '*'

    script:
    """
    pod5 convert fast5 \
        --threads ${task.cpus} \
        --recursive \
        $fast5 \
        --output .
    """

    stub:
    """
    
    """
}