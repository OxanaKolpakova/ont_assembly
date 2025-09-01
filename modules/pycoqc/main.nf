process PYCOQC {
    tag "$sid"
    conda 'bioconda::pycoqc'
    container 'nanozoo/pycoqc:2.5.0.23--320ecc7'
    cpus params.cpus
        
    input:
    tuple val(sid), path(fastq), path(bam)

    output:
    tuple val(sid), path("${sid}.html")
        
    script:
    """
     pycoQC \
        -f $fastq \
        -a $bam \
        -o ${sid}.html \
        --json ${sid}.json
    
    """
}