process INTERPROSCAN {
    tag "$sid"
    conda 'bioconda::interproscan'
    //container 'biocontainers/interproscan:v5.30-69.0_cv3'
    //errorStrategy 'ignore'
    cpus params.cpus 

    input:
    tuple val(sid), path(proteins)
    path(interproscan)

    output:
    tuple val(sid), path("${sid}.xml")
   
    script:
    """
    interproscan-5.75-106.0/interproscan.sh -i $proteins -f XML -o ${sid}.xml

    """
}

