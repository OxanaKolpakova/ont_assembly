include { FASTQC } from './modules/fastqc/'
include { MULTIQC } from './modules/multiqc/'
include { NANOFILT } from './modules/nanofilt/main.nf'
include { FASTQC as FASTQC_TRIMMED } from './modules/fastqc/'


workflow  {
    reads = Channel.fromPath(params.reads).map {it -> [it.simpleName, it]}
    FASTQC(reads)
    NANOFILT(reads)
    FASTQC_TRIMMED(NANOFILT.out)
    MULTIQC(
        FASTQC.out.zip.map{it[1]}
            .mix(FASTQC_TRIMMED.out.zip.map{it[1]}).collect()
        )

}