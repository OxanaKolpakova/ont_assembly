process MAFFT_2 {
    publishDir 'results/MAFFT_2'
    tag "all_samples"
    conda 'bioconda::mafft'
    container 'staphb/mafft:7.526'
    errorStrategy 'ignore'
    cpus params.cpus 

    input:
    path fasta

    output:
    path "aligned.fasta", emit: multifasta
       
    script:
    """
    mafft --auto $fasta > aligned.fasta 
    """
}