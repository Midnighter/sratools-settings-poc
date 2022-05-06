#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { SRA_DUMP } from './subworkflows/sra_dump'

workflow {
    def input = Channel.of(
        [[id: 'test1', single_end: true], 'DRR000774'],
        [[id: 'test2', single_end: true], 'DRR000775']
    )

    SRA_DUMP(input)
}