process CONCATENATE_FASTA {
    publishDir 'results/CONCATENATE_FASTA'
    tag "$sid"
    
    //errorStrategy 'ignore'
    cpus params.cpus 

    input:
    tuple val(sid), path(contigs_16S)
    path(fasta_16S_8N)
    path(fasta_16S_ss)

    output:
    tuple val(sid), path("${sid}_16S_concatenate.fasta"), emit: fasta
       
    script:
    """
    cat $contigs_16S $fasta_16S_8N $fasta_16S_ss > ${sid}_16S_concatenate.fasta
    """
}