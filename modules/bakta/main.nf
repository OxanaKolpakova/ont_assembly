process BAKTA {
    tag "$sid"
    conda 'bioconda::bakta'
    container 'oschwengers/bakta:v1.11.4'
    //errorStrategy 'ignore'
    cpus params.cpus 

    input:
    tuple val(sid), path(genome)
    path bakta_db
    
    output:       
    tuple val(sid), path("${sid}_bakta_results/${sid}.gff3"), emit: gff3
    tuple val(sid), path("${sid}_bakta_results/${sid}.gbff"), emit: gbff
    tuple val(sid), path("${sid}_bakta_results/${sid}.faa"), emit: faa
    tuple val(sid), path("${sid}_bakta_results/${sid}.ffn"), emit: ffn
    tuple val(sid), path("${sid}_bakta_results/${sid}.tsv"), emit: tsv 
    tuple val(sid), path("${sid}_bakta_results/${sid}.json"), emit: json   
    tuple val(sid), path("${sid}_bakta_results/${sid}.txt"), emit: txt
    tuple val(sid), path("${sid}_bakta_results/${sid}.embl"), emit: embl
    
    script:
    """
    export MPLCONFIGDIR='.mplconfig'
    mkdir -p .mplconfig

    bakta \
        --output ${sid}_bakta_results \
        --db ${bakta_db} \
        --prefix $sid \
        --genus "Streptomyces" \
        --species "albidoflavus" \
        --strain "INA01478" \
        --compliant \
        --verbose \
        --threads ${task.cpus} \
        ${genome}
        """
}