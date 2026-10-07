process PICARD_MARKDUP {
    tag "${meta.id}"
    label 'process_low'


    container 'community.wave.seqera.io/library/picard:3.5.0--d312a2f9bb99b1aa'

    input:
    tuple val(meta), path(sorted_bam)

    output:
    tuple val(meta), path("${meta.id}_marked.bam"), emit: bam
    tuple val(meta), path("${meta.id}_dup_metrics.txt"), emit: metrics, optional: true

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''

    """
    java -jar /opt/conda/share/picard-3.5.0-0/picard.jar AddOrReplaceReadGroups \\
        I=${sorted_bam} \\
        O=${meta.id}_rg.bam \\
        RGID=${meta.id} \\
        RGSM=${meta.id} \\
        RGLB=${meta.id} \\
        RGPL=Illumina \\
        RGPU=${meta.id} \\
        CREATE_INDEX=true

    java -jar /opt/conda/share/picard-3.5.0-0/picard.jar MarkDuplicates \\
        I=${meta.id}_rg.bam \\
        O=${meta.id}_marked.bam \\
        M=${meta.id}_dup_metrics.txt \\
        ASSUME_SORTED=true \\
        ${args}
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    touch ${prefix}_marked.bam
    touch ${prefix}_dup_metrics.txt
    """
}