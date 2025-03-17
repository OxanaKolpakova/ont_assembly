process GET_FASTA {
    publishDir 'results/GET_FASTA'
    tag "$sid"
    conda 'bioconda::bedtools'
    container 'staphb/bedtools:2.31.1'
    //errorStrategy 'ignore'
    cpus params.cpus 

    input:
    tuple val(sid), path(gff), path(contigs)

    output:
    tuple val(sid), path("${sid}_16S.fasta"), emit: fasta
       
    script:
    """
    grep -i "16S" $gff | awk '{print \$1 "\t" (\$4-1) "\t" \$5 "\t" \$9}' > ${sid}_16S.bed
    bedtools getfasta -fi "$contigs" -bed "${sid}_16S.bed" -fo "${sid}_16S_tmp.fasta"
    awk '/^>/ {split(\$0, a, ":"); print a[1] "_" ++i ":" a[2]; next} {print}' "${sid}_16S_tmp.fasta" > "${sid}_16S.fasta"
    """
}