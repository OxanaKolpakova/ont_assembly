include { convert_fast5_to_fastq             } from './subworkflows/convert_fast5_to_fastq.nf'
include { assembly_taxonomy_hybrid           } from './subworkflows/assembly_taxonomy_hybrid.nf'
include { annotation                         } from './subworkflows/annotation.nf'
include { MULTIQC                            } from './modules/multiqc/'

workflow {
    // dorado_models            = Channel.fromPath(params.dorado_models).collect()
    reads_long               = Channel.fromPath(params.reads_long).map {[it.simpleName, it]}
    reads_short              = Channel.fromFilePairs(params.reads_short, flat: true)
    reads                    = reads_long.join(reads_short). map {[it[0], it[1..-1]]}
    template_file           = Channel.fromPath(params.template_file).map{[it.simpleName, it]}
    protein_alignments      = Channel.fromPath(params.protein_alignments).collect()
    protein_evidence        = Channel.fromPath(params.protein_evidence).collect()
    protein_evidence_2      = Channel.fromPath(params.protein_evidence_2).collect()
    eggnog_proteins         = Channel.fromPath(params.eggnog_proteins).collect()
    interproscan            = Channel.fromPath(params.interproscan).collect()
    species_name            = Channel.fromPath(params.samplesheet)
        .splitCsv(header: true)
        .map{[it.sid, it.species_name]}
    strain_name             = Channel.fromPath(params.samplesheet)
        .splitCsv(header: true)
        .map{[it.sid, it.species_name]}
    //fast5 = Channel
    //    .fromPath("${params.fast5}/*fast5_pass*/*.fast5")
    //    .map { 
    //        file -> 
    //        def sid = file.getParent().getParent().getName()
    //        [ sid, file ] 
    //        }
    //    .groupTuple(by: 0)
    //convert_fast5_to_fastq(fast5, dorado_models)
    assembly_taxonomy_hybrid(reads)
    ch_annotation_input = assembly_taxonomy_hybrid.out.genome
        .join(template_file)
        .join(species_name)
        .join(strain_name)

    annotation(
        ch_annotation_input,
        params.busco_seed_species,
        protein_alignments,
        protein_evidence,
        protein_evidence_2,
        eggnog_proteins,
        interproscan,
    )
    ch_multiqc = assembly_taxonomy_hybrid.out.fastqc.map {it[1]}
        .mix(assembly_taxonomy_hybrid.out.fastqc_trimmed.map {it[1]})
        .mix(annotation.out.quast.map {it[1]})
        .collect()
    
    //MULTIQC(ch_multiqc)
}

