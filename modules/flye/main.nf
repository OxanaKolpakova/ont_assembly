process FLYE {
    publishDir 'results/FLYE'
    tag "$sid"
    conda 'bioconda::flye'
    container 'staphb/flye:2.9.5'
    errorStrategy 'ignore'
    cpus params.cpus

       
    input:
    tuple val(sid), path(reads)

    output:
    path "*"
    
    script:
    """
    flye --nano-corr $reads --out-dir output_directory --genome-size 7m --threads ${task.cpus}
    """
}