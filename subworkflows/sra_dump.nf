include { NCBI_SETTINGS } from '../modules/local/ncbi_settings'
include { SRATOOLS_PREFETCH } from '../modules/local/sratools_prefetch'
include { SRATOOLS_FASTERQDUMP } from '../modules/local/sratools_fasterqdump'

workflow SRA_DUMP {
    take:
    samples

    main:
    NCBI_SETTINGS()

    def settings = NCBI_SETTINGS.out.ncbi_settings.ifEmpty(file('EXISTS'))

    settings.dump()

    SRATOOLS_PREFETCH(samples, settings)

    SRATOOLS_PREFETCH.out.sra.dump()

    SRATOOLS_FASTERQDUMP(SRATOOLS_PREFETCH.out.sra, settings)

    SRATOOLS_FASTERQDUMP.out.reads.dump()
}