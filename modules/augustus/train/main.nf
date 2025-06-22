process AUGUSTUS_TRAIN {
    tag "$species_name"
    conda 'bioconda::augustus'
    container 'nanozoo/augustus:3.3.3--ed97e98'
    //errorStrategy 'ignore'
    cpus params.cpus 

    input:
    val species_name
    path augustus_train

    output:
    path "augustus_config/species/$species_name"
    
    script:
    """
    mkdir -p \$PWD/augustus_config/species
    cp -r /opt/conda/config/* \$PWD/augustus_config/
    export AUGUSTUS_CONFIG_PATH=\$PWD/augustus_config/
    new_species.pl --species=$species_name
    etraining --species=$species_name $augustus_train
    augustus --species=$species_name $augustus_train > /dev/null
    """
}