process CONCATENATE_ALL_FASTA {
    publishDir 'results/CONCATENATE_ALL_FASTA'
    tag "all_samples"
    //errorStrategy 'ignore'
    cpus params.cpus 

    input:
    path files

    output:
    path "concatenate.fasta", emit: fasta
       
    script:
    """
    cat $files > concatenate.fasta
    """
}