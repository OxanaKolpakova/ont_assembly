process FUNANNOTATE_IPRSCAN  {
    tag "$sid"
    
    conda 'bioconda::funannotate'
    container 'nextgenusfs/funannotate:v1.8.15'
    //errorStrategy 'ignore'
    cpus params.cpus 

    input:
    tuple val(sid), path(proteins)
    path(interproscan)
  
    output:
    tuple val(sid), path(fun_folder), emit: predict_dir

    script:
    """
    interproscan-5.75-106.0/interproscan.sh -i $proteins
    """
    }