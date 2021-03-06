#!/usr/bin/env nextflow

/*
 * Copyright (c) 2019-2020, Ontario Institute for Cancer Research (OICR).
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
 */

/*
 * author Junjun Zhang <junjun.zhang@oicr.on.ca>
 *        Linda Xiang <linda.xiang@oicr.on.ca>
 */

nextflow.preview.dsl=2

params.seq = ""
params.container_version = ""
params.ref_genome_gz = ""
params.cpus = 1
params.mem = 2  // in GB


include { alignedSeqQC; getAlignedQCSecondaryFiles } from '../aligned-seq-qc.nf' params(params)

Channel
  .fromPath(getAlignedQCSecondaryFiles(params.ref_genome_gz), checkIfExists: true)
  .set { ref_genome_gz_ch }

workflow {
  main:
    alignedSeqQC(
      file(params.seq),
      file(params.ref_genome_gz),
      ref_genome_gz_ch.collect(),
      true
    )

  publish:
    alignedSeqQC.out.metrics to: 'outdir', overwrite: true
}
