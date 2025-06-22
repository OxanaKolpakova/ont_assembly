process FUNANNOTATE_SORT {
    tag "$genome"
    
    conda 'bioconda::funannotate'
    container 'nextgenusfs/funannotate:v1.8.15  '
    errorStrategy 'ignore'
    cpus params.cpus 

    input:
    tuple val(sid), path(genome)
  
    output:
    tuple val(sid), path("${sid}_sorted.fa")

    script:
    """
    funannotate sort -i $genome -b scaffold -o ${sid}_sorted.fa
    """
    }