process INTERPROSCAN {
    tag "$sid"
    conda 'bioconda::interproscan'
    container 'biocontainers/interproscan:v5.30-69.0_cv3'
    //errorStrategy 'ignore'
    cpus params.cpus 

    input:
    tuple val(sid), path(proteins)

    output:
    tuple val(sid), path("${sid}.xml")
   
    script:
    """
    /opt/interproscan/interproscan.sh -i $proteins -f XML -o ${sid}.xml

    """
}

