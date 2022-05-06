process NCBI_SETTINGS {
    tag "ncbi-settings"
    label 'process_low'

    conda (params.enable_conda ? 'bioconda::sra-tools=2.11.0' : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/sra-tools:2.11.0--pl5262h314213e_0' :
        'quay.io/biocontainers/sra-tools:2.11.0--pl5262h314213e_0' }"

    output:
    path('user-settings.mkfg'), optional: true, emit: ncbi_settings

    when:
    task.ext.when == null || task.ext.when

    shell:
    config = "/LIBS/GUID = \"${UUID.randomUUID().toString()}\"\\n/libs/cloud/report_instance_identity = \"true\"\\n"
    template 'detect_ncbi_settings.sh'
}
