process TOP_HIT_BLAST {
    publishDir 'results/TOP_HIT_BLAST'
    tag "${r_sid}_${q_sid}"
    
    //errorStrategy 'ignore'
    cpus params.cpus 

    input:
    tuple val(r_sid), val(q_sid), path(blast_results), path(fasta)

    output:
    tuple val(r_sid), val(q_sid), path("${r_sid}_${q_sid}_top_hit.fasta"), emit: fasta
       
    script:
    """
    sort -k12,12nr $blast_results |\
        head -n 1 |\
        awk '{if (\$9 < \$10) print \$2":"\$9"-"\$10; else print \$2":"\$10"-"\$9}' |\
        xargs samtools faidx $fasta |\
        sed "s/^>.*\$/>${r_sid}/" > ${r_sid}_${q_sid}_top_hit.fasta
    """
}