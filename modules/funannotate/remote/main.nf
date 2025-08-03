process FUNANNOTATE_REMOTE {
    tag "$sid"
    
    conda 'bioconda::funannotate'
    container 'nextgenusfs/funannotate:v1.8.15'
    errorStrategy 'ignore'
    cpus params.cpus 

    input:
    tuple val(sid), path(fun_folder)
    val email
  
    output:
    tuple val(sid), path("${sid}_remote")


    script:
    """
    funannotate remote \
      --input $fun_folder \
      --methods antismash \
      --email $email \
      --out ${sid}_remote
    """
    }