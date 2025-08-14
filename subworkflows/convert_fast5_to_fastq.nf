include { DORADO                } from '../modules/dorado/'

workflow convert_fast5_to_fastq {
    take:
    fast5
    dorado_models
        
    main:
    DORADO(fast5, dorado_models)

    /*
    emit:
    quast   = QUAST.out
    gff     = FUNANNOTATE_ANNOTATE.out.gff
    */
}