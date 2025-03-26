process CONCATENATE_FASTA {
    publishDir 'results/CONCATENATE_FASTA'
    tag "$sid"
    
    //errorStrategy 'ignore'
    cpus params.cpus 

    input:
    tuple val(sid), path(contig_16S)
    path(all_16S)

    output:
    tuple val(sid), path("${sid}_16S_concatenate.fasta"), emit: fasta
       
    script:
    """
    cat $contig_16S $all_16S > ${sid}_16S_concatenate.fasta
    """
}