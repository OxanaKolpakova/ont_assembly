process MAFFT {
    publishDir 'results/MAFFT'
    tag "$sid"
    conda 'bioconda::mafft'
    container 'staphb/mafft:7.526'
    //errorStrategy 'ignore'
    cpus params.cpus 

    input:
    tuple val(sid), path(concatenate_16S)

    output:
    tuple val(sid), path("${sid}_aligned_16S.fasta"), emit: multifasta
       
    script:
    """
    mafft --auto $concatenate_16S > ${sid}_aligned_16S.fasta 
    """
}