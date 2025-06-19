process FUNANNOTATE_PREDICT {
    publishDir 'results/FUNANNOTATE_PREDICT'
    tag "$genome"
    
    conda 'bioconda::funannotate'
    container 'nextgenusfs/funannotate:v1.8.15  '
    //errorStrategy 'ignore'
    cpus params.cpus 

    input:
    val species_name
    tuple val(sid), path(genome)
    path species
  
    output:
    path "predict_output"


    script:
    """
    export AUGUSTUS_CONFIG_PATH=\$PWD/augustus_config/
    mkdir -p \$PWD/augustus_config/species 
    # cp -r \$AUGUSTUS_CONFIG_PATH \$PWD/augustus_config/
    # cp -r ${species} \$PWD/augustus_config/species/

    funannotate predict \
      -i $genome \
      -o predict_output \
      --species $species_name \
      --cpus ${task.cpus}
    """
    }