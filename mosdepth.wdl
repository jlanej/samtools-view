version 1.0
task viewRegion {
    input {
        File bam_or_cram_input
        File bam_or_cram_index=bam_or_cram_input+".crai"
        String outputRoot
        String region
        File ref
        File ref_fasta_index
        File ref_dict
        Int mem_gb
        Int addtional_disk_size = 100 
        Int machine_mem_size = 15
   		Int disk_size = ceil(size(bam_or_cram_input, "GB")) + addtional_disk_size

    }

# ./mosdepth -n -t 1 --by 1000 --fasta 1000genomes.grch38.fasta-index/genome.fa 6018628_23153_0_0.by1000 6018628_23153_0_0.cram
	command {
		bash -c "echo ~{bam_or_cram_input}; mosdepth; mosdepth -n -t 1 --by 1000 --fasta ~{ref} ~{bam_or_cram_input} ~{outputRoot}"
	}

	output {
			File coverageBed = "~{outputRoot}.regions.bed.gz"
		    File coverageBedCSI = "~{outputRoot}.regions.bed.gz.csi"
            File globalDistOutput="~{outputRoot}.mosdepth.global.dist.txt"
            File distOutput="~{outputRoot}.mosdepth.region.dist.txt"
            File summaryOutput="~{outputRoot}.mosdepth.summary.txt"


	}

	runtime {
		docker: "quay.io/jlanej/mosdepth-docker:sha256:6c31a803fad8ed5873cbd856b057039ced23768cf260d7317c57b0f7a9663e11"
		memory: mem_gb + "GB"
		disks: "local-disk " + disk_size + " HDD"
	}

	meta {
		author: "jlanej"
	}
}

workflow extractRegionWorkflow {
    input {
        File bam_or_cram_input
        String outputRoot
        String region
        File ref
        File ref_fasta_index
        File ref_dict
        Int mem_gb
    }
	call viewRegion { 
		input:
	 bam_or_cram_input=bam_or_cram_input,
	 region=region,
	 outputRoot=outputRoot,
	 ref=ref,
	 ref_fasta_index=ref_fasta_index,
	 ref_dict=ref_dict,
	 mem_gb=mem_gb 
	}
}

#		
