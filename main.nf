include { assembly_taxonomy_hybrid           } from './subworkflows/assembly_taxonomy_hybrid.nf'
include { MULTIQC                            } from './modules/multiqc/'

reads_long               = Channel.fromPath(params.reads_long).map {[it.simpleName, it]}
reads_short              = Channel.fromFilePairs(params.reads_short, flat: true)
reads                    = reads_long.join(reads_short). map {[it[0], it[1..-1]]}

workflow {
    assembly_taxonomy_hybrid(reads)
}