process IQTREE {
    publishDir 'results/IQTREE'
    tag "$sid"
    conda 'bioconda::iqtree'
    container 'staphb/iqtree:1.6.7'
    //errorStrategy 'ignore'
    cpus params.cpus 

    input:
    tuple val(sid), path(fasta)

    output:
    tuple val(sid), path("*.treefile"), emit: nwk
       
    script:
    """
    iqtree -s $fasta -m MFP -bb 1000 -alrt 1000 -nt 8
    """
}