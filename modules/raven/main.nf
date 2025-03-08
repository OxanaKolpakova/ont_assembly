process RAVEN {
    publishDir 'results/RAVEN'
    tag "$reads"
    conda 'bioconda::raven-assembler'
    container 'nanozoo/raven:1.5.0--9806f08'
    
    
    input:
    tuple val(sid), path(reads)

    output:
    path "${sid}.fasta"
    
    script:
    """
    raven --threads 8 --no-filter $reads > ${sid}.fasta
    """
}