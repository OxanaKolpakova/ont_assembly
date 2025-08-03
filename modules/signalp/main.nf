process SIGNALP {
    tag "$sid"
    conda 'bioconda::signalp'
    container 'doejgi/signalp:v5'
    errorStrategy 'ignore'
    cpus params.cpus 

    input:
    tuple val(sid), path(proteins)

    output:
    tuple val(sid), path("*.signalp5")

    script:
    """
    signalp -fasta $proteins -org euk -format short
    """
}

