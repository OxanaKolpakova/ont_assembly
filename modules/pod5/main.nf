process POD5 {
    container 'staphb/pod5:0.3.27'
//	  debug true
//    errorStrategy 'ignore'
    cpus params.cpus 

    input:
    tuple val(sid), path(fast5)

    output:
    tuple val(sid), path("${sid}.pod5")

    script:
    """
    pod5 convert fast5 \
        --threads ${task.cpus} \
        --recursive \
        $fast5 \
        --output ${sid}.pod5
    """

    stub:
    """
    
    """
}