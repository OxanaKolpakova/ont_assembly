process BEDTOOLS_INTERSECT {
    publishDir 'results/BEDTOOLS_INTERSECT'
    tag "$sid"
    conda 'bioconda::bedtools'
    container 'staphb/bedtools:2.31.1'
    //errorStrategy 'ignore'
    cpus params.cpus
       
    input:
    tuple val(sid), path(bam), path(bam_bai) 
    path(bed)

    output:
    tuple val(sid), path("${sid}_${bed.simpleName}.bam")
    
    script:
    """
    bedtools intersect -a $bam -b $bed > ${sid}_${bed.simpleName}.bam
    """
}