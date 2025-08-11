process UNICYCLER {
    tag "$sid"
    conda 'bioconda::unicycler'
    container 'staphb/unicycler:0.5.1'
    // errorStrategy 'ignore'
    cpus params.cpus

    input:
    tuple val(sid), path(reads)

    output:
    tuple val(sid), path("${sid}.fa")

    script:
    """
    unicycler \
        -1 ${reads[1]} \
        -2 ${reads[2]} \
        -l ${reads[0]} \
        -o ${sid}_assembly \
        --threads ${task.cpus} \
        --mode bold
    mv ${sid}_assembly/assembly.fasta ${sid}.fa
    """
}