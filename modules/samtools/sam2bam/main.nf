process SAMTOOLS_SAM2BAM {
    tag "$sid"
    conda 'bioconda::samtools'
    container 'glebusasha/bwa_samtools:latest'
    //errorStrategy 'ignore'
    cpus params.cpus
       
    input:
    tuple val(sid), path(sam) 
        
    output:
    tuple val(sid), path("${sid}.bam")
    
    script:
    """
    samtools view -@ ${task.cpus} -bS $sam | samtools sort -@ ${task.cpus} -o ${sid}.bam
    """
}