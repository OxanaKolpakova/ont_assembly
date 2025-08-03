include { FASTQC                             } from '../modules/fastqc/'
include { FASTQC as FASTQC_TRIMMED           } from '../modules/fastqc/'
include { NANOFILT                           } from '../modules/nanofilt/'
include { FASTP                              } from '../modules/fastp/'

/*
include { FASTQC as FASTQC_TRIMMED           } from '../modules/fastqc/'
include { MINIMAP2                           } from '../modules/minimap2/'
include { SAMTOOLS_FAIDX                     } from '../modules/samtools/faidx/'
include { SAMTOOLS_SAM2BAM                   } from '../modules/samtools/sam2bam/'
include { SAMTOOLS_SORT                      } from '../modules/samtools/sort/'
include { SAMTOOLS_INDEX                     } from '../modules/samtools/index/'
include { SAMTOOLS_FLAGSTAT                  } from '../modules/samtools/flagstat/'
include { SAMTOOLS_VIEW                      } from '../modules/samtools/view/'
include { MOSDEPTH                           } from '../modules/mosdepth/'
include { MEDAKA_CONSENSUS                   } from '../modules/medaka/'*/

workflow assembly_taxonomy_hybrid {
    take:
    reads
    
    main:
    FASTQC(reads)

    long_reads    = reads.map{[it[0], it[1][0]]}
    short_reads   = reads.map{[it[0], it[1][1..2]]}

    NANOFILT(long_reads)
    FASTP(short_reads)
    FASTQC_TRIMMED(NANOFILT.out.join(FASTP.out.trimmed_reads).map {[it[0], it[1..-1]]})
    
    /*
    MINIMAP2(NANOFILT.out, reference) 
    SAMTOOLS_SAM2BAM(MINIMAP2.out)
    SAMTOOLS_SORT(SAMTOOLS_SAM2BAM.out)
    SAMTOOLS_INDEX(SAMTOOLS_SORT.out)
    SAMTOOLS_FLAGSTAT(SAMTOOLS_SORT.out.join(SAMTOOLS_INDEX.out))
    MOSDEPTH(SAMTOOLS_SORT.out.join(SAMTOOLS_INDEX.out))
    MEDAKA_CONSENSUS(SAMTOOLS_SORT.out.join(SAMTOOLS_INDEX.out), reference, SAMTOOLS_FAIDX.out)*/
    
    emit:
    fastqc              = FASTQC.out.zip
    /*fastqc_trimmed      = FASTQC_TRIMMED.out.zip
    samtools_flagstat   = SAMTOOLS_FLAGSTAT.out
    genome              = MEDAKA_CONSENSUS.out
    mosdepth_global_dist  = MOSDEPTH.out.global_dist
    mosdepth_summary      = MOSDEPTH.out.summary*/
}