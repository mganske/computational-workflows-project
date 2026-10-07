process SAMTOOLS_SORT {
    tag "${meta.id}"
    label 'process_low'


    container "${workflow.containerEngine in ['singularity', 'apptainer'] && !task.ext.singularity_pull_docker_container
        ? 'https://depot.galaxyproject.org/singularity/samtools:latest'
        : 'docker.io/staphb/samtools:latest'}"


    input:
    tuple val(meta), path(sam)

    output:
    tuple val(meta), path("${meta.id}_sorted.bam"), emit: bam

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    samtools view -bS ${args} ${sam} | samtools sort -o ${meta.id}_sorted.bam
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    touch ${prefix}_sorted.bam
    """
}