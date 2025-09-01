process NANOFILT {
    tag "$sid"
    conda 'bioconda::nanofilt conda-forge::gzip'
    container 'mcfonsecalab/nanofilt:latest'
    
    input:
    tuple val(sid), path(reads)

    output:
    tuple val(sid), path("${sid}_filtered.fastq.gz")
    
    script:
    """
    zcat -f $reads | NanoFilt -q 10 -l 50 --headcrop 50 | gzip > "${sid}_filtered.fastq.gz"
    """
}