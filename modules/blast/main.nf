process BLAST {
    publishDir 'results/BLAST'
    tag "$sid"
    conda 'bioconda::blast'
    container 'staphb/blast:2.16.0'
    //errorStrategy 'ignore'
    cpus params.cpus
       
    input:
    tuple val(sid), path(fasta)
    path daidzeins

    output:
    tuple val(sid), path("${sid}_blast_results.tsv"), emit: tsv
    
    script:
    """
    makeblastdb -in $fasta -dbtype nucl -out genome_db
    blastn -query $daidzeins -db genome_db -outfmt 6 -out ${sid}_blast_results.tsv
    """
}