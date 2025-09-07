process FUNANNOTATE_FIX {
    tag "$sid"
    
    conda 'bioconda::funannotate'
    container 'nextgenusfs/funannotate:v1.8.15'
    //errorStrategy 'ignore'
    cpus params.cpus 

    input:
    tuple val(sid), path(gbk), path(tbl)

    output:
    tuple val(sid), path("${sid}_fixed"), emit: fixed

    script:
    """
    funannotate fix \\
      --input $gbk \\
      --tbl $tbl \\
      --out ${sid}_fixed
    """
    }