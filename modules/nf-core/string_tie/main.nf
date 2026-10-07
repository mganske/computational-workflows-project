process STRING_TIE {
    tag "${meta.id}"
    label 'process_low'

    container 'community.wave.seqera.io/library/stringtie:3.0.3--0dbd954bb1f6ce76'

    input:
    tuple val(meta), path(sorted_bam)
    path(gtf)

    output:
    tuple val(meta), path("${meta.id}_stringtie.gtf"), emit: gtf
    tuple val(meta), path("${meta.id}_abundance.tsv"), emit: tpm

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    /opt/conda/bin/stringtie ${sorted_bam} \\
        -G ${gtf} \\
        -o ${meta.id}_stringtie.gtf \\
        -A ${meta.id}_abundance.tsv \\
        -p ${task.cpus ?: 1} \\
        ${args}
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    touch ${prefix}_stringtie.gtf
    touch ${prefix}_abundance.tsv
    """
}