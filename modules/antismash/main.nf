process ANTISMASH {
    tag "${sid}"
    conda 'bioconda::antismash'
    container 'antismash/standalone:8.0.1'
    //errorStrategy 'ignore'
    cpus params.cpus
       
    input:
    tuple val(sid), path(genome), path(gbk)
    
    output:
    tuple val(sid), path("${sid}_antismash"), emit: antismash_folder
    tuple val(sid), path("${sid}_antismash/${sid}.gbk"), emit: gbk

    script:
    """
    antismash \
        --taxon fungi \
        --genefinding-too none \
        --cpus ${task.cpus} \
        --output-dir ${sid}_antismash \
        --output-basename $sid \
        --clusterhmmer \
        --pfam2go \
        --cb-general \
        --cc-mibig \
        $gbk
    """
}