process FUNANNOTATE_TRAIN {
    tag "$sid"
    
    conda 'bioconda::funannotate'
    container 'nextgenusfs/funannotate:v1.8.15  '
    //errorStrategy 'ignore'
    cpus params.cpus 

    input:
    val species_name
    tuple val(sid), path(funannotate_predict)

    output:
    path "predict_output"


    script:
    """
    funannotate annotate -i $funannotate_predict \
      --species $species_name \
      --antismash \
      --cpus $task.cpus
      """
    }