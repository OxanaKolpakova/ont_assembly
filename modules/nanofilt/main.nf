process NANOFILT {
    publishDir 'results/NANOFILT'
    tag "$reads"
    conda 'bioconda::nanofilt conda-forge::gzip'
    input:
    path reads

    output:
    path "${reads.simpleName}_trimmed.fastq.gz"
    
    script:
    """
    gunzip -c $reads | NanoFilt -q 10 -l 500 --headcrop 50 | gzip > ${reads.simpleName}_trimmed.fastq.gz
    """
}