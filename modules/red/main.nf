process RED {
publishDir 'results/RED'
    tag "$sid"
    conda 'bioconda::red'
    container 'genomehubs/redmask:latest'
    cpus params.cpus

    input:
    tuple val(sid), path(fasta)

    output:
    tuple val(sid), path("${sid}.softmasked.fa")   

    script:
    """
    redmask.py -i $fasta -o ${sid}
    """
}