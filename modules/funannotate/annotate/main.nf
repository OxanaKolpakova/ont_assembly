process FUNANNOTATE_ANNOTATE {
    tag "$sid"
    
    conda 'bioconda::funannotate'
    container 'nextgenusfs/funannotate:v1.8.15'
    //errorStrategy 'ignore'
    cpus params.cpus 

    input:
    val species_name
    path template_file
    tuple val(sid), path(fun_folder), path(antismash), path(emapper_annotations), path(phobius), path(signalp), path(iprscan)

    output:
    tuple val(sid), path("${fun_folder}/annotate_results"), emit: funannotate_annotate
    tuple val(sid), path("${fun_folder}/annotate_results/${species_name}*.gff3"), emit: gff

    script:
    """
    funannotate annotate -i $fun_folder \
      --species $species_name \
      --cpus $task.cpus \
      --sbt $template_file \
      --out ${sid}_annotate \
      --antismash $antismash \
      --eggnog $emapper_annotations \
      --phobius $phobius \
      --signalp $signalp \
      --iprscan $iprscan \
      --force
    """
    }