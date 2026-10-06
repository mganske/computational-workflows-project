#!/usr/bin/env nextflow
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    mganske/course-2026-project
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Github : https://github.com/mganske/course-2026-project
----------------------------------------------------------------------------------------
*/

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT FUNCTIONS / MODULES / SUBWORKFLOWS / WORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

<<<<<<< HEAD
include { COURSE_2026_PROJECT  } from './workflows/course-2026-project'
include { PIPELINE_INITIALISATION } from './subworkflows/local/utils_nfcore_course-2026-project_pipeline'
include { PIPELINE_COMPLETION     } from './subworkflows/local/utils_nfcore_course-2026-project_pipeline'
include { getGenomeAttribute      } from './subworkflows/local/utils_nfcore_course-2026-project_pipeline'
=======
include { COMPUTATIONAL_WORKFLOWS_PROJECT  } from './workflows/computational-workflows-project'
include { PIPELINE_INITIALISATION          } from './subworkflows/local/utils_nfcore_computational-workflows-project_pipeline'
include { PIPELINE_COMPLETION              } from './subworkflows/local/utils_nfcore_computational-workflows-project_pipeline'
include { getGenomeAttribute               } from './subworkflows/local/utils_nfcore_computational-workflows-project_pipeline'
>>>>>>> 6fd033a5342ca23e61e79aaff34a05c7c9490482

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    GENOME PARAMETER VALUES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

// TODO nf-core: Remove this line if you don't need a FASTA file
//   This is an example of how to use getGenomeAttribute() to fetch parameters
//   from igenomes.config using `--genome`
params.fasta = getGenomeAttribute('fasta')

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    NAMED WORKFLOWS FOR PIPELINE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//
// WORKFLOW: Run main analysis pipeline depending on type of input
//
<<<<<<< HEAD
workflow MGANSKE_COURSE_2026_PROJECT {
=======
workflow MGANSKE_COMPUTATIONAL_WORKFLOWS_PROJECT {
>>>>>>> 6fd033a5342ca23e61e79aaff34a05c7c9490482

    take:
    samplesheet // channel: samplesheet read in from --input

    main:

    //
    // WORKFLOW: Run pipeline
    //
<<<<<<< HEAD
    COURSE_2026_PROJECT (
=======
    COMPUTATIONAL_WORKFLOWS_PROJECT (
>>>>>>> 6fd033a5342ca23e61e79aaff34a05c7c9490482
        samplesheet,
        params.multiqc_config,
        params.multiqc_logo,
        params.multiqc_methods_description,
        params.outdir,
    )
    emit:
<<<<<<< HEAD
    multiqc_report = COURSE_2026_PROJECT.out.multiqc_report // channel: /path/to/multiqc_report.html
=======
    multiqc_report = COMPUTATIONAL_WORKFLOWS_PROJECT.out.multiqc_report // channel: /path/to/multiqc_report.html
>>>>>>> 6fd033a5342ca23e61e79aaff34a05c7c9490482
}
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow {

    main:
    //
    // SUBWORKFLOW: Run initialisation tasks
    //
    PIPELINE_INITIALISATION (
        params.version,
        params.validate_params,
        params.monochrome_logs,
        args,
        params.outdir,
        params.input,
        params.help,
        params.help_full,
        params.show_hidden
    )

    //
    // WORKFLOW: Run main workflow
    //
<<<<<<< HEAD
    MGANSKE_COURSE_2026_PROJECT (
=======
    MGANSKE_COMPUTATIONAL_WORKFLOWS_PROJECT (
>>>>>>> 6fd033a5342ca23e61e79aaff34a05c7c9490482
        PIPELINE_INITIALISATION.out.samplesheet
    )

    //
    // SUBWORKFLOW: Run completion tasks
    //
    PIPELINE_COMPLETION (
        params.email,
        params.email_on_fail,
        params.plaintext_email,
        params.outdir,
        params.monochrome_logs,
<<<<<<< HEAD
        MGANSKE_COURSE_2026_PROJECT.out.multiqc_report
=======
        MGANSKE_COMPUTATIONAL_WORKFLOWS_PROJECT.out.multiqc_report
>>>>>>> 6fd033a5342ca23e61e79aaff34a05c7c9490482
    )
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
