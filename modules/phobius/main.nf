process PHOBIUS {
    tag "$sid"
    conda 'bioconda::phobius'
    container 'barbarahelena/phobius:1.01'
    errorStrategy 'ignore'
    cpus params.cpus 

    input:
    tuple val(sid), path(proteins)

    output:
    tuple val(sid), path("${sid}_phobius.txt")

    script:
    """
    phobius $proteins -short > ${sid}_phobius.txt
    """
}

