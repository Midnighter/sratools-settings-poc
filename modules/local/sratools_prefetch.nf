process SRATOOLS_PREFETCH {
    tag "$id"
    label 'process_low'
    label 'error_retry'

    conda (params.enable_conda ? 'bioconda::sra-tools=2.11.0' : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/sra-tools:2.11.0--pl5262h314213e_0' :
        'quay.io/biocontainers/sra-tools:2.11.0--pl5262h314213e_0' }"

    input:
    tuple val(meta), val(id)
    path(ncbi_settings)

    output:
    tuple val(meta), path("$id"), emit: sra
    path "versions.yml"         , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    if [[ "${ncbi_settings.name}" != "EXISTS" ]]; then
        export NCBI_SETTINGS="\$PWD/${ncbi_settings}"
    fi

    prefetch \\
        $args \\
        $id

    vdb-validate $id

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        sratools: \$(prefetch --version 2>&1 | grep -Eo '[0-9.]+')
    END_VERSIONS
    """
}
