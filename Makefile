

RELEASE_REPO_BRANCH=release-`cat RELEASE_VERSION`
PIPELINE_MANIFEST_BRANCH=$RELEASE_REPO_BRANCH
# May be in RedHat main org or in some ACM specific org
PIPELINE_MANIFEST_ORG ?= stolostron
# The "product" name that is used for release repo; release=RHACM, backplane=backplane
PIPELINE_PRODUCT_PREFIX ?= release
# Release version of the product
PIPELINE_MANIFEST_RELEASE_VERSION ?= $(subst $(PIPELINE_PRODUCT_PREFIX)-,,$(PIPELINE_MANIFEST_BRANCH))
# Release version of the product based on the branch it came from
PIPELINE_MANIFEST_SHA_RELEASE_VERSION ?= $(PIPELINE_MANIFEST_RELEASE_VERSION) 
# Pipeline manifest file names
PIPELINE_MANIFEST_FILE_NAME ?= downstream-2023-10-12-14-53-11-2.9.0
#quay
PIPELINE_MANIFEST_RETAG_REPO ?= quay
# Repo name not yet confirmed
PIPELINE_MANIFEST_REPO?= pipeline



# .PHONY: pipeline-manifest/_retag
# # Validate and retag all images or git repos identified in manifest
# pipeline-manifest/_retag: %_retag:
# 	echo manifest-parser.py $(PIPELINE_MANIFEST_FILE_NAME).json $(PIPELINE_PRODUCT_PREFIX)
# 	@python3 manifest-parser.py $(PIPELINE_MANIFEST_FILE_NAME).json $(TAG) true $(PIPELINE_MANIFEST_RETAG_REPO) $(PIPELINE_MANIFEST_SHA_RELEASE_VERSION) $(PIPELINE_MANIFEST_REPO) $(PIPELINE_MANIFEST_ORG) $(PIPELINE_PRODUCT_PREFIX)
# 	@python3 manifest-parser.py $(PIPELINE_MANIFEST_FILE_NAME).json $(TAG) false $(PIPELINE_MANIFEST_RETAG_REPO) $(PIPELINE_MANIFEST_SHA_RELEASE_VERSION) $(PIPELINE_MANIFEST_REPO) $(PIPELINE_MANIFEST_ORG) $(PIPELINE_PRODUCT_PREFIX)


# VSingle SBOMifier
pipeline-sboms:
	echo manifest-parser.py $(PIPELINE_MANIFEST_FILE_NAME) pipeline-sboms
	@python3 manifest-parser.py $(PIPELINE_MANIFEST_FILE_NAME) pipeline-sboms

# VSingle SBOMifier
json-to-csv:
	echo manifest-parser.py $(PIPELINE_MANIFEST_FILE_NAME).json json-to-csv
	@python3 manifest-parser.py $(PIPELINE_MANIFEST_FILE_NAME).json json-to-csv

final-csv:
	cyclonedx convert --input-file final-product.cdx.json --output-file final-product.cdx.csv


# VSingle SBOMifier
master-sbom:
# echo sbomasm assemble -n "ACM 2.9 SBOM" -v "1.0.0" -t "application" -o final-product.cdx.json sboms/components/*/*
	sbomasm assemble -c acm-config.yaml -o final-product.cdx.json sboms/$(PIPELINE_MANIFEST_FILE_NAME)/*
# python manifest-parser.py manifest.json $(TAG) true quay release-$(RELEASE_VERSION) pipeline stolostron release