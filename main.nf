include { FASTQC                             } from './modules/fastqc/'
include { MULTIQC                            } from './modules/multiqc/'
include { NANOFILT                           } from './modules/nanofilt/'
include { FASTQC as FASTQC_TRIMMED           } from './modules/fastqc/'
include { FLYE                               } from './modules/flye/'
include { RAVEN                              } from './modules/raven/'
include { MINIMAP2                           } from './modules/minimap2/'
include { SAMTOOLS_FAIDX                     } from './modules/samtools/faidx/'
include { SAMTOOLS_SAM2BAM                   } from './modules/samtools/sam2bam/'
include { SAMTOOLS_SORT                      } from './modules/samtools/sort/'
include { SAMTOOLS_INDEX                     } from './modules/samtools/index/'
include { SAMTOOLS_FLAGSTAT                  } from './modules/samtools/flagstat/'
include { SAMTOOLS_VIEW                      } from './modules/samtools/view/'
include { MEDAKA_CONSENSUS                   } from './modules/medaka/'
include { QUAST                              } from './modules/quast/'
include { PROKKA                             } from './modules/prokka/'
include { GET_FASTA                          } from './modules/local/get_fasta/'
include { CONCATENATE_FASTA                  } from './modules/local/concatenate_fasta/'
include { MAFFT                              } from './modules/mafft/'
include { MAFFT_2                            } from './modules/mafft_2/'
include { FAST_TREE                          } from './modules/fast_tree/'
include { IQTREE                             } from './modules/iqtree/'
include { BEDTOOLS_INTERSECT                 } from './modules/bedtools/intersect/'
include { SAMTOOLS_INDEX as SAMTOOLS_INDEX_2 } from './modules/samtools/index/'
include { CONCATENATE_ALL_FASTA              } from './modules/local/concatenate_all_fasta/'
include { BLAST                              } from './modules/blast/'
include { ITSX                               } from './modules/itsx/'  
include { TOP_HIT_BLAST                      } from './modules/local/top_hit_blast'
include { LONG_HIT_BLAST                     } from './modules/local/long_hit_blast'
include { AUGUSTUS_TRAIN                     } from './modules/augustus/train/'
include { AUGUSTUS_PREDICT                   } from './modules/augustus/predict/'
include { FUNANNOTATE_PREDICT                } from './modules/funannotate/predict/'

reads           = Channel.fromPath(params.reads).map {it -> [it.simpleName, it]}
reference       = Channel.fromPath(params.reference).collect()
musroom_prot    = Channel.fromPath(params.musroom_prot).map {it -> [it.simpleName, it]}
species_name    = params.species_name
augustus_train = Channel.fromPath(params.augustus_train).collect()
workflow assembly_taxonomy {
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
    QUAST(MEDAKA_CONSENSUS.out)
    ITSX(MEDAKA_CONSENSUS.out)
    BLAST(MEDAKA_CONSENSUS.out.combine(musroom_prot))
    LONG_HIT_BLAST(BLAST.out.tsv.combine(MEDAKA_CONSENSUS.out, by: 0))

    /*
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
            .mix(QUAST.out.map{it[1]})
            //.mix(PROKKA.out.prokka.map{it[1]})
            .collect()
        )
    
    emit:
    genome = MEDAKA_CONSENSUS.out
}

workflow annotation {
    take:
    species_name
    //augustus_train
    genome

    main:
    AUGUSTUS_TRAIN(species_name, augustus_train)
    AUGUSTUS_PREDICT(species_name, genome, AUGUSTUS_TRAIN.out)
    //FUNANNOTATE_PREDICT(AUGUSTUS_PREDICT.out, AUGUSTUS_TRAIN.out, species_name)
    //FUNANNOTATE_PREDICT(species_name, genome, AUGUSTUS_TRAIN.out)
   
}
workflow {
    assembly_taxonomy(reads, reference, musroom_prot)
    //annotation(species_name, augustus_train, assembly_taxonomy.out.genome)
    annotation(species_name, assembly_taxonomy.out.genome)
}