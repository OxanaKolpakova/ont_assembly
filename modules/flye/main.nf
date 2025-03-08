process FLYE {
    publishDir 'results/FLYE'
    tag "$reads"
    conda 'bioconda::flye'
    container 'staphb/flye:2.9.5'
    memory '6 GB'
    
    input:
    tuple val(sid), path(reads)

    output:
    path "*"
    
    script:
    """
    flye --nano-raw $reads --out-dir output_directory --genome-size 5m --threads 8 --asm-coverage 100
    """
}