process FLYE {
    tag "$sid"
    conda 'bioconda::flye'
    container 'staphb/flye:2.9.5'
    errorStrategy 'ignore'
    cpus params.cpus

       
    input:
    tuple val(sid), path(reads)

    output:
    tuple val(sid), path("${sid}_flye.fasta")
    
    script:
    """
    flye --nano-corr $reads --out-dir output_directory --genome-size 7m --threads ${task.cpus}
    mv output_directory/assembly.fasta ${sid}_flye.fasta
    """
}