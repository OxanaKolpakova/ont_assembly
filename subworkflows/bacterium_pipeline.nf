workflow bacterium_pipeline {
    take:
    reads
    reference
    musroom_prot
    
    main:
    //contig_16S_8N   = Channel.fromPath(params.contig_16S_8N).collect()
    //ssampsonii_16S  = Channel.fromPath(params.ssampsonii_16S).collect()
    //all_16S         = Channel.fromPath(params.all_16S).collect()
    //all_rnpB        = Channel.fromPath(params.all_rnpB).collect()
    //rnpB            = Channel.fromPath(params.rnpB).collect()
    //daidzeins       = Channel.fromPath(params.daidzeins)

    SAMTOOLS_FAIDX(reference)
    FASTQC(reads)
    NANOFILT(reads)
    FASTQC_TRIMMED(NANOFILT.out)
    MINIMAP2(NANOFILT.out, reference) 
    SAMTOOLS_SAM2BAM(MINIMAP2.out)
    SAMTOOLS_SORT(SAMTOOLS_SAM2BAM.out)
    SAMTOOLS_INDEX(SAMTOOLS_SORT.out)
    SAMTOOLS_FLAGSTAT(SAMTOOLS_SORT.out.join(SAMTOOLS_INDEX.out))
    MEDAKA_CONSENSUS(SAMTOOLS_SORT.out.join(SAMTOOLS_INDEX.out), reference, SAMTOOLS_FAIDX.out)
    /*
    QUAST(MEDAKA_CONSENSUS.out)
    ITSX(MEDAKA_CONSENSUS.out)
    BLAST(MEDAKA_CONSENSUS.out.combine(musroom_prot))
    LONG_HIT_BLAST(BLAST.out.tsv.combine(MEDAKA_CONSENSUS.out, by: 0))

   
    TOP_HIT_BLAST(BLAST.out.tsv.combine(MEDAKA_CONSENSUS.out, by: 0))
    PROKKA(MEDAKA_CONSENSUS.out)
    CONCATENATE_FASTA(TOP_HIT_BLAST.out.fasta, all_rnpB)
    MAFFT(CONCATENATE_FASTA.out.fasta)
    FAST_TREE(MAFFT.out.multifasta)
    IQTREE(MAFFT.out.multifasta, "CP121214.1_3255908-3256318")
    IQTREE(MAFFT.out.multifasta, "AB184187.1") 16S their
    IQTREE(MAFFT.out.multifasta)
    */
    MULTIQC(
        FASTQC.out.zip.map{it[1]}
            .mix(FASTQC_TRIMMED.out.zip.map{it[1]})
            .mix(SAMTOOLS_FLAGSTAT.out.map{it[1]})
            //.mix(QUAST.out.map{it[1]})
            //.mix(PROKKA.out.prokka.map{it[1]})
            .collect()
        )
    
    emit:
    genome = MEDAKA_CONSENSUS.out
}