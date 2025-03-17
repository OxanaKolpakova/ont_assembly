include { FASTQC                    } from './modules/fastqc/'
include { MULTIQC                   } from './modules/multiqc/'
include { NANOFILT                  } from './modules/nanofilt/'
include { FASTQC as FASTQC_TRIMMED  } from './modules/fastqc/'
include { FLYE                      } from './modules/flye/'
include { RAVEN                     } from './modules/raven/'
include { MINIMAP2                  } from './modules/minimap2/'
include { SAMTOOLS_FAIDX            } from './modules/samtools/faidx/'
include { SAMTOOLS_SAM2BAM          } from './modules/samtools/sam2bam/'
include { SAMTOOLS_INDEX            } from './modules/samtools/index/'
include { SAMTOOLS_FLAGSTAT         } from './modules/samtools/flagstat/'
include { MEDAKA_CONSENSUS          } from './modules/medaka/'
include { QUAST                     } from './modules/quast/'
include { PROKKA                    } from './modules/prokka/'
include { GET_FASTA                 } from './modules/local/get_fasta/'
include { CONCATENATE_FASTA         } from './modules/local/concatenate_fasta/'
include { MAFFT                     } from './modules/mafft/'
include { FAST_TREE                 } from './modules/fast_tree/'

workflow  {
    reads           = Channel.fromPath(params.reads).map {it -> [it.simpleName, it]}
    reference       = Channel.fromPath(params.reference).collect()
    contig_16S_8N   = Channel.fromPath(params.contig_16S_8N).collect()
    ssampsonii_16S  = Channel.fromPath(params.ssampsonii_16S).collect()

    FASTQC(reads)
    NANOFILT(reads)
    FASTQC_TRIMMED(NANOFILT.out)
    //FLYE(NANOFILT.out)
    //RAVEN(NANOFILT.out)
    //RAVEN(reads)
    MINIMAP2(NANOFILT.out, reference) 
    SAMTOOLS_FAIDX(reference)
    SAMTOOLS_SAM2BAM(MINIMAP2.out)
    SAMTOOLS_INDEX(SAMTOOLS_SAM2BAM.out)
    SAMTOOLS_FLAGSTAT(SAMTOOLS_SAM2BAM.out.join(SAMTOOLS_INDEX.out))
    MEDAKA_CONSENSUS(SAMTOOLS_SAM2BAM.out.join(SAMTOOLS_INDEX.out), reference, SAMTOOLS_FAIDX.out)
    QUAST(MEDAKA_CONSENSUS.out)
    PROKKA(MEDAKA_CONSENSUS.out)
    GET_FASTA(PROKKA.out.gff.join(MEDAKA_CONSENSUS.out))
    CONCATENATE_FASTA(GET_FASTA.out, contig_16S_8N, ssampsonii_16S)
    MAFFT(CONCATENATE_FASTA.out.fasta)
    FAST_TREE(MAFFT.out.multifasta)
    MULTIQC(
        FASTQC.out.zip.map{it[1]}
            .mix(FASTQC_TRIMMED.out.zip.map{it[1]})
            .mix(SAMTOOLS_FLAGSTAT.out.map{it[1]})
            .mix(QUAST.out.map{it[1]})
            .mix(PROKKA.out.prokka.map{it[1]})
            .collect()
        )
}