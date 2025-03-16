process MINIMAP2 {
    publishDir 'results/MINIMAP2'
    tag "$sid"
    conda 'bioconda::minimap2'
    container 'staphb/minimap2:2.28'
    //errorStrategy 'ignore'
    cpus params.cpus

    input:
    tuple val(sid), path(reads) 
    path(reference)
    
    output:
    tuple val(sid), path("${sid}.sam")
    
    script:
    """
    minimap2 -ax map-ont -t ${task.cpus} $reference $reads > ${sid}.sam 
    """
}