process EGGNOG_MAPPER {
    tag "$sid"
    conda 'bioconda::eggnog-mapper'
    container 'dataspott/eggnog-mapper:2.1.8--2022-07-11'
    //errorStrategy 'ignore'
    cpus params.cpus 

    input:
    tuple val(sid), path(proteins)
    path eggnog_proteins

    output:
    tuple val(sid), path("${sid}.emapper.annotations"), emit: emapper_annotations
   
    script:
    """
    emapper.py \
        -i $proteins \
        -o $sid \
        --data_dir $eggnog_proteins \
        --cpu ${task.cpus}
    """
}

