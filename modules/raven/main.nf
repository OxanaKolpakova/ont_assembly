process RAVEN {
    publishDir 'results/RAVEN'
    tag "$sid"
    conda 'bioconda::raven-assembler'
    container 'nanozoo/raven:1.5.0--9806f08'
    cpus params.cpus
    
    input:
    tuple val(sid), path(reads)

    output:
    path "${sid}.fasta"
    
    script:
    """
    raven --threads ${task.cpus} --no-filter $reads > ${sid}.fasta
    """
}