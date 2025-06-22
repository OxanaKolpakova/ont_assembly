process AUGUSTUS_PREDICT {
    tag "$sid"
    conda 'bioconda::augustus'
    container 'nanozoo/augustus:3.3.3--ed97e98'
    //errorStrategy 'ignore'
    cpus params.cpus 

    input:
    val species_name
    tuple val(sid), path(genome)
    path species

    output:
    path "${sid}.gff3"
   
    script:
    """
    mkdir -p \$PWD/augustus_config/species
    cp -r /opt/conda/config/* \$PWD/augustus_config/
    cp -r ${species} \$PWD/augustus_config/species/
    export AUGUSTUS_CONFIG_PATH=\$PWD/augustus_config/
    augustus --species=$params.species_name $genome > ${sid}.gff3
    """
}

