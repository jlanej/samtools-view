version 1.0

task runmosdepth {
    input {
        File bam_or_cram_input
        File bam_or_cram_index=bam_or_cram_input+".crai"
        String outputRoot
        File ref
        File ref_fasta_index
        File ref_dict
        Int mem_gb
        Int addtional_disk_size = 100 
        Int machine_mem_size = 15
   		Int disk_size = ceil(size(bam_or_cram_input, "GB")) + addtional_disk_size

    }
	command {
		bash -c "echo ~{bam_or_cram_input}; mosdepth; mosdepth -n -t 1 --by 1000 --fasta ~{ref} ~{outputRoot} ~{bam_or_cram_input}"
	}

	output {
			File coverageBed = "~{outputRoot}.regions.bed.gz"
		    File coverageBedCSI = "~{outputRoot}.regions.bed.gz.csi"
            File globalDistOutput="~{outputRoot}.mosdepth.global.dist.txt"
            File distOutput="~{outputRoot}.mosdepth.region.dist.txt"
            File summaryOutput="~{outputRoot}.mosdepth.summary.txt"


	}

	runtime {
		docker: "quay.io/jlanej/mosdepth-docker:sha256:3ab57446d67f81cba88e051afe0f33d63684fdf6f1f54decf6591890f16bc176"
		memory: mem_gb + "GB"
		disks: "local-disk " + disk_size + " HDD"
	}

	meta {
		author: "jlanej"
	}
}

workflow mosdepthWorkflow {
    input {
        File bam_or_cram_input
        String outputRoot
        File ref
        File ref_fasta_index
        File ref_dict
        Int mem_gb
    }
	call runmosdepth { 
		input:
	 bam_or_cram_input=bam_or_cram_input,
	 outputRoot=outputRoot,
	 ref=ref,
	 ref_fasta_index=ref_fasta_index,
	 ref_dict=ref_dict,
	 mem_gb=mem_gb 
	}
}

#		new version
