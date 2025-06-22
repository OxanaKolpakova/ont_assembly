include { FASTQC                             } from './modules/fastqc/'
include { MULTIQC                            } from './modules/multiqc/'
include { NANOFILT                           } from './modules/nanofilt/'
include { FASTQC as FASTQC_TRIMMED           } from './modules/fastqc/'
include { MINIMAP2                           } from './modules/minimap2/'
include { SAMTOOLS_FAIDX                     } from './modules/samtools/faidx/'
include { SAMTOOLS_SAM2BAM                   } from './modules/samtools/sam2bam/'
include { SAMTOOLS_SORT                      } from './modules/samtools/sort/'
include { SAMTOOLS_INDEX                     } from './modules/samtools/index/'
include { SAMTOOLS_FLAGSTAT                  } from './modules/samtools/flagstat/'
include { SAMTOOLS_VIEW                      } from './modules/samtools/view/'
include { MEDAKA_CONSENSUS                   } from './modules/medaka/'
include { FUNANNOTATE_CLEAN                  } from './modules/funannotate/clean/'
include { FUNANNOTATE_SORT                   } from './modules/funannotate/sort/'
include { FUNANNOTATE_MASK                   } from './modules/funannotate/mask/'
include { FUNANNOTATE_PREDICT                } from './modules/funannotate/predict/'
include { FUNANNOTATE_ANTISMASH              } from './modules/funannotate/antismash/'
include { FUNANNOTATE_ANNOTATE               } from './modules/funannotate/annotate/'
include { ANTISMASH                          } from './modules/antismash/'
include { EGGNOG_MAPPER                      } from './modules/eggnog_mapper/'
include { INTERPROSCAN                       } from './modules/interproscan/'
include { QUAST                              } from './modules/quast/'


reads               = Channel.fromPath(params.reads).map {it -> [it.simpleName, it]}
reference           = Channel.fromPath(params.reference).collect()
eggnog_proteins     = Channel.fromPath(params.eggnog_proteins).collect()
species_name        = Channel.value(params.species_name)
strain_name         = Channel.value(params.strain_name)
busco_seed_species  = Channel.value(params.busco_seed_species)
protein_alignments  = Channel.value(params.protein_alignments)
protein_evidence    = Channel.value(params.protein_evidence)
protein_evidence_2  = Channel.value(params.protein_evidence_2)


workflow assembly_taxonomy {
    take:
    reads
    reference
    
    main:
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
    
    emit:
    fastqc = FASTQC.out.zip
    fastqc_trimmed = FASTQC_TRIMMED.out.zip
    samtools_flagstat = SAMTOOLS_FLAGSTAT.out
    genome = MEDAKA_CONSENSUS.out

}

workflow annotation {
    take:
    genome
    species_name
    strain_name
    busco_seed_species
    protein_alignments
    protein_evidence
    protein_evidence_2
    eggnog_proteins
    
    main:
    FUNANNOTATE_CLEAN(genome)
    FUNANNOTATE_SORT(FUNANNOTATE_CLEAN.out)
    FUNANNOTATE_MASK(FUNANNOTATE_SORT.out)
    FUNANNOTATE_PREDICT(
        FUNANNOTATE_MASK.out, 
        species_name, 
        strain_name, 
        busco_seed_species,
        protein_alignments,
        protein_evidence,
        protein_evidence_2
        )
    ANTISMASH(FUNANNOTATE_MASK.out.join(FUNANNOTATE_PREDICT.out.gbk))
    EGGNOG_MAPPER(FUNANNOTATE_PREDICT.out.proteins, eggnog_proteins)
    //INTERPROSCAN(FUNANNOTATE_PREDICT.out.proteins)
    FUNANNOTATE_ANNOTATE(
        species_name, 
        FUNANNOTATE_PREDICT.out.predict_dir.join(ANTISMASH.out.gbk).join(EGGNOG_MAPPER.out.emapper_annotations)
        )
    QUAST(FUNANNOTATE_MASK.out.join(FUNANNOTATE_ANNOTATE.out.gff))
    
    emit:
    quast   = QUAST.out
    gff     = FUNANNOTATE_ANNOTATE.out.gff
}

workflow {
    assembly_taxonomy(reads, reference)
    annotation(
        assembly_taxonomy.out.genome, 
        species_name, 
        strain_name, 
        busco_seed_species, 
        protein_alignments, 
        protein_evidence,
        protein_evidence_2,
        eggnog_proteins
        )
    MULTIQC(
        assembly_taxonomy.out.fastqc.map{it[1]}
        .mix(assembly_taxonomy.out.fastqc_trimmed.map{it[1]})
        .mix(assembly_taxonomy.out.samtools_flagstat.map{it[1]})
        .mix(annotation.out.quast.map{it[1]})
        .collect()
    )
}