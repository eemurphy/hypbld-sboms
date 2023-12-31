INPUT_FILE_NAME ?= MCE-manifest-2023-11-02-15-37-00-2.4.0
FINAL_FILE_NAME ?= $(INPUT_FILE_NAME).sbom.json
CONFIG_FILE_NAME ?= mce-config

pipeline-sboms:
	echo scripts/manifest-parser.py $(INPUT_FILE_NAME)
	@python3 scripts/manifest-parser.py $(INPUT_FILE_NAME)

csv:
	cyclonedx convert --input-file sboms/$(INPUT_FILE_NAME)/$(FINAL_FILE_NAME) --output-file sboms/$(INPUT_FILE_NAME)/$(INPUT_FILE_NAME).sbom.csv

# add IF FINAL_FILE EXIST THEN DELETE FINAL_FILE
master-sbom:
	sbomasm assemble -c scripts/config/$(CONFIG_FILE_NAME).yaml -o sboms/$(INPUT_FILE_NAME)/$(FINAL_FILE_NAME) sboms/$(INPUT_FILE_NAME)/*

clean: 
	echo scripts/jsoncleaner.py sboms/$(INPUT_FILE_NAME)/$(FINAL_FILE_NAME) false
	@python3 scripts/jsoncleaner.py sboms/$(INPUT_FILE_NAME)/$(FINAL_FILE_NAME) false
