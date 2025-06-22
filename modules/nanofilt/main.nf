process NANOFILT {
    tag "$sid"
    conda 'bioconda::nanofilt conda-forge::gzip'
    container 'jdelling7igfl/nanofilt:2.8.0'
    
    input:
    tuple val(sid), path(reads)

    output:
    tuple val(sid), path("${sid}_filtered.fastq.gz")
    
    script:
    """
    gunzip -c $reads | NanoFilt -q 10 -l 50 --headcrop 50 | gzip > ${sid}_filtered.fastq.gz
    """
}