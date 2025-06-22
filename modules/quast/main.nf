process QUAST {
    tag "$sid"
    conda 'bioconda::quast'
    container 'staphb/quast:5.3.0'
    //errorStrategy 'ignore'
    cpus params.cpus
       
    input:
    tuple val(sid), path(genome), path(gff)
    
    output:
    tuple val(sid), path("${sid}")
    
    script:
    """
    quast.py \
        ${genome} \
        --features ${gff} \
        -o ${sid} \
        --threads ${task.cpus}
    """
}