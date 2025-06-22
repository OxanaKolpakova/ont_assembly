process FAST_TREE {
    tag "$sid"
    conda 'bioconda::fasttree'
    container 'staphb/fasttree:2.1.11'
    //errorStrategy 'ignore'
    cpus params.cpus 

    input:
    tuple val(sid), path(fasta)

    output:
    tuple val(sid), path("${sid}.nwk"), emit: nwk
       
    script:
    """
    FastTree -gtr -nt $fasta > ${sid}.nwk 
    """
}