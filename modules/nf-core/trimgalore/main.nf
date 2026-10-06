process TRIMGALORE {
    tag "${meta.id}"
    label 'process_low'

    container "${workflow.containerEngine in ['singularity', 'apptainer'] && !task.ext.singularity_pull_docker_container
    ? 'https://depot.galaxyproject.org/singularity/trim-galore:0.6.10--hdfd78af_0'
    : 'quay.io/biocontainers/trim-galore:0.6.10--hdfd78af_0'}"

    input:
    tuple val(meta), path(reads)

    output:
    path("*{3prime,5prime,trimmed,val}{,_1,_2}.fq.gz")
    tuple val(meta), path("*report.txt"), emit: log, optional: true
    //tuple("${task.process}"), val('trimgalore'), eval('trim_galore --version | grep -Eo "[0-9]+(\\.[0-9]+)+"'), emit: versions_trimgalore, topic: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"

    // core: -3 single-end, -4 paired-end, clamp 1..8
    def cores = meta.single_end
    ? Math.max((task.cpus as int) - 3, 1)
    : Math.max((task.cpus as int) - 4, 1)
    cores = Math.min(cores, 8)
    
    // default single-end
    def fq1 = "${prefix}.fastq.gz"
    def fq2 = ''
    def paired = ''

    if (!meta.single_end) {
        fq1 = "${prefix}_1.fastq.gz"
        fq2 = "${prefix}_2.fastq.gz"
        paired = '--paired'
    }

    """
    if [ -n "${fq2}" ]; then
        [ -f "${fq1}" ] || ln -s ${reads[0]} ${fq1}
        [ -f "${fq2}" ] || ln -s ${reads[1]} ${fq2}
    else
        [ -f "${fq1}" ] || ln -s ${reads[0]} ${fq1}
    fi

    trim_galore \\
        ${args} \\
        --cores ${cores} \\
        ${paired} \\
        --gzip \\
        ${fq1} ${fq2}
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}"
    if (meta.single_end) {
        """
        echo '' | gzip > ${prefix}_trimmed.fq.gz
        touch ${prefix}.fastq.gz_trimming_report.txt
        """
    } else {
        """
        echo '' | gzip > ${prefix}_1_val_1.fq.gz
        echo '' | gzip > ${prefix}_2_val_2.fq.gz
        touch ${prefix}_1.fastq.gz_trimming_report.txt
        touch ${prefix}_2.fastq.gz_trimming_report.txt
        """
    }
}