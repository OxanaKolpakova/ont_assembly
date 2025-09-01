include { POD5                  } from '../modules/pod5/'
include { DORADO                } from '../modules/dorado/'

workflow convert_fast5_to_fastq {
    take:
    fast5
    dorado_models
        
    main:
    POD5(fast5)
    DORADO(POD5.out, dorado_models)

    emit:
    fastq   = DORADO.out 
}