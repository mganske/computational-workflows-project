process HISAT2 {
    tag "${meta.id}"
    label 'process_low'
    //process.arch = 'linux/amd64'

container "${workflow.containerEngine in ['singularity', 'apptainer'] && !task.ext.singularity_pull_docker_container
    ? 'https://depot.galaxyproject.org/singularity/hisat2:2.2.1--he1b5a44_2'
    : 'quay.io/biocontainers/hisat2:2.2.1--he1b5a44_2'}"

    input:
    tuple val(meta), path(fq1), val(fq2)
    path(index_dir) 
    val cores

    output:
    tuple val(meta), path("${meta.id}.sam"), emit: sam
    //path "${meta.id}_alignment_summary.txt", emit: summary
    path "${meta.id}.log", emit: log, optional: true

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def is_paired = fq2 != null//boolean
    def index_base = "${index_dir}/${params.hisat2_index.tokenize('/')[-1]}"

    """
    hisat2 -p ${cores} \\
        ${args} \\
        -x ${index_base} \\
        -1 ${fq1} \\
        ${is_paired ? "-2 ${fq2}" : ''} \\
        -S ${meta.id}.sam \\
        2> ${meta.id}.log
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    touch ${meta.id}.sam
    touch ${meta.id}.log
    """
}