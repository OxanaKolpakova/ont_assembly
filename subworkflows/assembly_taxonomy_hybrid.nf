include { FASTQC                             } from '../modules/fastqc/'
include { FASTQC as FASTQC_TRIMMED           } from '../modules/fastqc/'
include { NANOFILT                           } from '../modules/nanofilt/'
include { FASTP                              } from '../modules/fastp/'
include { UNICYCLER                          } from '../modules/unicycler/'
include { QUAST                              } from '../modules/quast/'

workflow assembly_taxonomy_hybrid {
    take:
    reads
    
    main:
    long_reads    = reads.map{[it[0], it[1][0]]}
    short_reads   = reads.map{[it[0], it[1][1..2]]}
    FASTQC(reads)
    
    NANOFILT(long_reads)
    FASTP(short_reads)
    
    filtered_reads = NANOFILT.out.join(FASTP.out.trimmed_reads).map {[it[0], it[1..-1]]}
    
    FASTQC_TRIMMED(filtered_reads)
    UNICYCLER(filtered_reads)
    
    emit:
    fastqc              = FASTQC.out.zip
    fastqc_trimmed      = FASTQC_TRIMMED.out.zip
    genome              = UNICYCLER.out
}