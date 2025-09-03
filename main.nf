include { convert_fast5_to_fastq             } from './subworkflows/convert_fast5_to_fastq.nf'
include { assembly_taxonomy_long             } from './subworkflows/assembly_taxonomy_long.nf'
include { PYCOQC                             } from './modules/pycoqc'
include { BAKTA                              } from './modules/bakta'
include { QUAST                              } from './modules/quast'
include { BUSCO                              } from './modules/busco'
include { MULTIQC                            } from './modules/multiqc/'

workflow {
    dorado_models            = Channel.fromPath(params.dorado_models).collect()
    reference                = Channel.fromPath(params.reference).collect()
    busco_db                 = Channel.fromPath(params.busco_db).collect()
    
    fast5 = Channel
        .fromPath("${params.fast5}/*fast5_pass*/*.fast5")
        .map { 
            file -> 
            def sid = file.getParent().getParent().getName()
            [ sid, file ] 
            }
        .groupTuple(by: 0)

    convert_fast5_to_fastq(fast5, dorado_models)
    assembly_taxonomy_long(convert_fast5_to_fastq.out.fastq, reference)
    //PYCOQC(convert_fast5_to_fastq.out.fastq.join(assembly_taxonomy_long.out.bam))
    BAKTA(assembly_taxonomy_long.out.genome, params.bakta_db)
    QUAST(assembly_taxonomy_long.out.genome.join(BAKTA.out.gff3))
    BUSCO(
        assembly_taxonomy_long.out.genome, 
        busco_db
        )
    ch_multiqc = assembly_taxonomy_long.out.fastqc.map {it[1]}
        .mix(assembly_taxonomy_long.out.fastqc_trimmed.map {it[1]})
        .mix(assembly_taxonomy_long.out.samtools_flagstat.map {it[1]})
        .mix(assembly_taxonomy_long.out.mosdepth_global_dist.map {it[1]})
        .mix(assembly_taxonomy_long.out.mosdepth_summary.map {it[1]})
        .mix(BAKTA.out.txt.map {it[1]})
        .mix(BUSCO.out.txt.map {it[1]})
        .mix(QUAST.out.map {it[1]})

        .collect()
    
    MULTIQC(ch_multiqc)
}

