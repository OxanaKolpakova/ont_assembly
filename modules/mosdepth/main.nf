process MOSDEPTH {
    container 'nanozoo/mosdepth:0.3.2--892ca95'
    conda 'mosdepth'
    cpus params.cpus
    tag {
        sid.length() > 40 ? "${sid.take(20)}...${sid.takeRight(20)}" : sid
    }
//    debug true
//    errorStrategy 'ignore'

    input:
    tuple val(sid), path(bam), path(bamIndex)

    output:
    tuple val(sid), path("${sid}.mosdepth.global.dist.txt"), emit: global_dist
    tuple val(sid), path("${sid}.mosdepth.summary.txt")    , emit: summary

    script:
    """
    mosdepth \
        -n \
        -t ${task.cpus} \
        ${sid} ${bam}
    """
}