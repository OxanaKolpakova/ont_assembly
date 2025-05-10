process BLAST {
    publishDir 'results/BLAST'
    tag "$r_sid $q_sid"
    conda 'bioconda::blast'
    container 'staphb/blast:2.16.0'
    //errorStrategy 'ignore'
    cpus params.cpus
       
    input:
    tuple val(r_sid), path(reference), val(q_sid), path(query)
    
    output:
    tuple val(r_sid),val(q_sid), path("${r_sid}_${q_sid}_blast.tsv"), emit: tsv
    
    script:
    """
    makeblastdb -in $reference -dbtype nucl -out genome_db
    blastn -query $query -db genome_db -outfmt 6 -out ${r_sid}_${q_sid}_blast.tsv
    """
}