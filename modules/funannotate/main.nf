process FUNANNOTATE {
    publishDir 'results/FUNANNOTATE'
    tag "$sid"
    conda 'bioconda::funannotate'
    container 'nextgenusfs/funannotate:latest'
    cpus params.cpus

    input:
    tuple val(sid), path(fasta)

    output:
    tuple val(sid), path("*")

    script:
    """
    funannotate predict \
        -i $fasta \
        -o ${sid} \
        --species "Emericellopsis" \
        --cpus ${task.cpus} \
        --header_length 100
    """
}