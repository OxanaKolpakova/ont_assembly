process TOP_HIT_BLAST {
    publishDir 'results/TOP_HIT_BLAST'
    tag "$sid"
    
    //errorStrategy 'ignore'
    cpus params.cpus 

    input:
    tuple val(sid), path(blast_results), path(fasta)

    output:
    tuple val(sid), path("${sid}_top_hit.fasta"), emit: fasta
       
    script:
    """
    sort -k12,12nr $blast_results |\
        head -n 1 |\
        awk '{if (\$9 < \$10) print \$2":"\$9"-"\$10; else print \$2":"\$10"-"\$9}' |\
        xargs samtools faidx $fasta |\
        sed "s/^>.*\$/>${sid}/" > ${sid}_top_hit.fasta
    """
}