process FUNANNOTATE_CLEAN {
    tag "$genome"
    
    conda 'bioconda::funannotate'
    container 'nextgenusfs/funannotate:v1.8.15  '
    errorStrategy 'ignore'
    cpus params.cpus 

    input:
    tuple val(sid), path(genome)
  
    output:
    tuple val(sid), path("${sid}_cleaned.fa")

    script:
    """
    funannotate clean -i $genome --minlen 1000 -o ${sid}_cleaned.fa
    """
    }