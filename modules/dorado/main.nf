process DORADO {
    container 'staphb/dorado:0.8.3'
    tag {
        sid.length() > 40 ? "${sid.take(20)}...${sid.takeRight(20)}" : sid
    }
//	  debug true
//    errorStrategy 'ignore'
    cpus params.cpus 

    input:
    tuple val(sid), path(pod5)
    path dorado_models

    output:
    tuple val(sid), path("${sid}.fastq")

    script:
    """
    mkdir tmp
    dorado basecaller $dorado_models $pod5 \
        --emit-fastq \
        --recursive \
        --device auto > ${sid}.fastq
    """

    stub:
    """
    
    """
}