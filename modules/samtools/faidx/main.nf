process SAMTOOLS_FAIDX {
    tag "$reference"
    conda 'bioconda::samtools'
    container 'glebusasha/bwa_samtools:latest'
    //errorStrategy 'ignore'
       
    input:
    path(reference) 
       
    output:
    path("*.fai")
    
    script:
    """
    samtools faidx $reference
    """
}