process FUNANNOTATE_PREDICT {
    tag "$genome"
    
    conda 'bioconda::funannotate'
    container 'nextgenusfs/funannotate:v1.8.15'
    errorStrategy 'ignore'
    cpus params.cpus 

    input:
    tuple val(sid), path(genome), val(species_name), val(strain_name)
    val busco_seed_species
    path protein_alignments
    path protein_evidence
    path protein_evidence_2
  
    output:
    tuple val(sid), path("${sid}_predict"), emit: predict_dir
    tuple val(sid), path("${sid}_predict/predict_results/*.gbk"), emit: gbk
    tuple val(sid), path("${sid}_predict/predict_results/*.proteins.fa"), emit: proteins


    script:
    """
    funannotate predict \
      -i $genome \
      -o ${sid}_predict \
      --species '$species_name' \
      --strain '$strain_name' \
      --busco_seed_species $busco_seed_species \
      --protein_evidence $protein_evidence $protein_evidence_2 \
      --optimize_augustus \
      --cpus ${task.cpus}
    """
    }