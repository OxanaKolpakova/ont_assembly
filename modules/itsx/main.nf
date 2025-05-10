process ITSX {
    publishDir 'results/ITSX'
    tag "$sid"
    conda 'bioconda::itsx'
    container 'metashot/itsx:1.1.2-1'
    //errorStrategy 'ignore'
    cpus params.cpus 

    input:
    tuple val(sid), path(fasta)

    output:
            
    tuple val(sid), path("*")
    
    script:
    """
    ITSx -i $fasta -o $sid --preserve T --save_regions all --cpu ${task.cpus}
    """
}