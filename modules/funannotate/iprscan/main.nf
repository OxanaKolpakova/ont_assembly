process FUNANNOTATE_IPRSCAN  {
    tag "$sid"
    
    conda 'bioconda::funannotate'
    container 'nextgenusfs/funannotate:v1.8.15  '
    //errorStrategy 'ignore'
    cpus params.cpus 

    input:
    tuple val(sid), path(fun_folder)

  
    output:
    tuple val(sid), path("${sid}_iprscan")


    script:
    """
    funannotate iprscan \
      --input $fun_folder \
      --methods singularity \
      --cpus ${task.cpus} \
      --out ${sid}_iprscan
    """
    }