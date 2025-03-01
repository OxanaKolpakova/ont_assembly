params.reads = '/home/oxana/projects/8N/fastq_pass/barcode19/*.fastq.gz'

process FASTQC {
    publishDir 'results'
    input:
    path reads

    output:
    path '*'

    script:
    """
    fastqc $reads -t 2
    """
}
workflow  {
    reads = Channel.fromPath(params.reads)
    FASTQC(reads)
}