process FUNANNOTATE_MASK {
    tag "$genome"
    
    conda 'bioconda::funannotate'
    container 'nextgenusfs/funannotate:v1.8.15  '
    errorStrategy 'ignore'
    cpus params.cpus 

    input:
    tuple val(sid), path(genome)
  
    output:
    tuple val(sid), path("${sid}_masked.fa")

    script:
    """
    funannotate mask -i $genome -o ${sid}_masked.fa
    """
    }