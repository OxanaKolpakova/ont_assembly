process FUNANNOTATE_ANTISMASH {
    tag "$sid"
    
    conda 'bioconda::funannotate'
    container 'nextgenusfs/funannotate:v1.8.15  '
    errorStrategy 'ignore'
    cpus params.cpus 

    input:
    tuple val(sid), path(fun_folder)
    val email
  
    output:
    tuple val(sid), path("${sid}_antismash")


    script:
    """
    funannotate remote \
      -i $fun_folder \
      -m antismash \
      -e $email \
      -o ${sid}_antismash
    """
    }