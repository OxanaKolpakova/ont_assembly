process QUAST {
    publishDir 'results/QUAST'
    tag "$sid"
    conda 'bioconda::quast'
    container 'staphb/quast:5.3.0'
    //errorStrategy 'ignore'
    cpus params.cpus
       
    input:
    tuple val(sid), path(contigs)
    
    output:
    tuple val(sid), path("${sid}")
    
    script:
    """
    quast.py ${contigs} -o ${sid} -t ${task.cpus}
    """
}