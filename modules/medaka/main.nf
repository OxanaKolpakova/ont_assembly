process MEDAKA_CONSENSUS {
    publishDir 'results/MEDAKA_CONSENSUS'
    tag "$sid"
    conda 'bioconda::medaka'
    container 'staphb/medaka:2.0.1'
    //errorStrategy 'ignore'
    cpus params.cpus 

    input:
    tuple val(sid), path(bam), path(bai) 
    path(reference)
    path(faindex)  

    output:
    tuple val(sid), path("${sid}.fa")
    
    script:
    """
    medaka_consensus -i $bam -d $reference -o ${sid}_out -t ${task.cpus}
    mv ${sid}_out/consensus.fasta ${sid}.fa
    """
}