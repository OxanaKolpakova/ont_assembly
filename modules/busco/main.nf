process BUSCO {
    tag "$sid"
    
    conda 'bioconda::busco'
    container 'ezlabgva/busco:v6.0.0_cv1'
    //errorStrategy 'ignore'
    cpus params.cpus 

    input:
    tuple val(sid), path(genome)
    path busco_db
    
    output:
    tuple val(sid),  path("${sid}_busco_results/short_summary.*.txt"), emit: txt
   
    script:
    """
    mkdir -p ./busco_downloads/lineages
    mv $busco_db ./busco_downloads/lineages
    busco \
        --in ${genome} \
        --lineage_dataset ${busco_db} \
        --out ${sid}_busco_results \
        --mode genome \
        --cpu ${task.cpus} \
        --offline \
        --force
    """
  
    }