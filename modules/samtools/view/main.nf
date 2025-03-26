process SAMTOOLS_VIEW {
    publishDir 'results/SAMTOOLS_VIEW'
    tag "$sid"
    conda 'bioconda::samtools'
    container 'glebusasha/bwa_samtools:latest'
    //errorStrategy 'ignore'
       
    input:
    tuple val(sid), path(bam) 
    path bed
       
    output:
    tuple val(sid), path("${sid}_trimmed.bam")
    
    script:
    """
    region=\$(awk '{print \$1":"\$2"-"\$3}' "$bed")
    samtools view -hb $bam "\$region" > ${sid}_trimmed.bam
    """
}