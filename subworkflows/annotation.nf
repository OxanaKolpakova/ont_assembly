include { FUNANNOTATE_CLEAN                  } from '../modules/funannotate/clean/'
include { FUNANNOTATE_SORT                   } from '../modules/funannotate/sort/'
include { FUNANNOTATE_MASK                   } from '../modules/funannotate/mask/'
include { FUNANNOTATE_PREDICT                } from '../modules/funannotate/predict/'
include { FUNANNOTATE_ANTISMASH              } from '../modules/funannotate/antismash/'
include { FUNANNOTATE_ANNOTATE               } from '../modules/funannotate/annotate/'
include { FUNANNOTATE_FIX                    } from '../modules/funannotate/fix/'
include { INTERPROSCAN                       } from '../modules/interproscan/'
include { ANTISMASH                          } from '../modules/antismash/'
include { PHOBIUS                            } from '../modules/phobius/'
include { SIGNALP                            } from '../modules/signalp/'
include { EGGNOG_MAPPER                      } from '../modules/eggnog_mapper/'
include { QUAST                              } from '../modules/quast/'

workflow annotation {
    take:
    genome_template_file_species_name_strain_name
    busco_seed_species
    protein_alignments
    protein_evidence
    protein_evidence_2
    eggnog_proteins
    interproscan
    
    main:
    genome          = genome_template_file_species_name_strain_name.map {[it[0], it[1]]}
    template_file   = genome_template_file_species_name_strain_name.map {[it[0], it[2]]}
    species_name    = genome_template_file_species_name_strain_name.map {[it[0], it[3]]}
    strain_name     = genome_template_file_species_name_strain_name.map {[it[0], it[4]]}


    FUNANNOTATE_CLEAN(genome)
    FUNANNOTATE_SORT(FUNANNOTATE_CLEAN.out)
    FUNANNOTATE_MASK(FUNANNOTATE_SORT.out)
    FUNANNOTATE_PREDICT(
        FUNANNOTATE_MASK.out.join(species_name).join(strain_name),
        busco_seed_species,
        protein_alignments,
        protein_evidence,
        protein_evidence_2
        )
    ANTISMASH(FUNANNOTATE_MASK.out.join(FUNANNOTATE_PREDICT.out.gbk))
    PHOBIUS(FUNANNOTATE_PREDICT.out.proteins)
    SIGNALP(FUNANNOTATE_PREDICT.out.proteins)
    EGGNOG_MAPPER(FUNANNOTATE_PREDICT.out.proteins, eggnog_proteins)
    INTERPROSCAN(FUNANNOTATE_PREDICT.out.proteins, interproscan)
    FUNANNOTATE_ANNOTATE(
        species_name
        .join(template_file) 
        .join(FUNANNOTATE_PREDICT.out.predict_dir)   
        .join(ANTISMASH.out.gbk)
        .join(EGGNOG_MAPPER.out.emapper_annotations)
        .join(PHOBIUS.out)
        .join(SIGNALP.out)
        .join(INTERPROSCAN.out)
        )
    FUNANNOTATE_FIX(FUNANNOTATE_ANNOTATE.out.gbk.join(FUNANNOTATE_ANNOTATE.out.tbl))
    QUAST(FUNANNOTATE_MASK.out.join(FUNANNOTATE_ANNOTATE.out.gff))
    
    emit:
    quast   = QUAST.out
    gff     = FUNANNOTATE_ANNOTATE.out.gff
}