process PROKKA {
    publishDir 'results/PROKKA'
    tag "$sid"
    conda 'bioconda::prokka'
    container 'nanozoo/prokka:1.14.6--c99ff65'
    //errorStrategy 'ignore'
    cpus params.cpus 

    input:
    tuple val(sid), path(contigs)

    output:
    tuple val(sid), path("${sid}_prokka")           , emit: prokka
    tuple val(sid), path("${sid}_prokka/${sid}.gff"), emit: gff
    
    script:
    """
    prokka --outdir ${sid}_prokka --prefix $sid --cpus ${task.cpus} $contigs
    """
}