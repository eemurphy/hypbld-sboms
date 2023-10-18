import json
import sys
import os
import re
from subprocess import run

# Parameters:
#  sys.argv[1] - filename of manifest.json to parse ---- manifest.json
#  sys.argv[2] - textual tag ----- $(TAG) ???
#  sys.argv[3] - boolean: dry run/validate (true) vs. actually do the tagging (false) ------ true
#  sys.argv[4] - textual name of repo to do the tagging in (git|quay) ----- quay
#  sys.argv[5] - z-release "name" (i.e. 2.0.1)  ------ release-$(RELEASE_VERSION)
#  sys.argv[6] - PIPELINE_MANIFEST_REPO (pipelie|backplane-pipeline) ------ pipeline
#  sys.argv[7] - PIPELINE_MANIFEST_ORG ------ stolostron
#  sys.argv[8] - "product" name (release|backplane) ------ release

        # "image-name": "multiclusterhub-operator",
        # "image-version": "2.9",
        # "image-tag": "2.9.0-e79c0f82cce325b4c8c69296193a88da5d8f31e0",
        # "git-branch": "release-2.9",
        # "git-sha256": "e79c0f82cce325b4c8c69296193a88da5d8f31e0",
        # "git-repository": "stolostron/multiclusterhub-operator",
        # "image-remote": "quay.io/stolostron",
        # "image-digest": "sha256:a397fe156fbeb7a38a170b78cef557f9771a1fecf22d5c61393be87159050b2d",
        # "image-key": "multiclusterhub_operator",
        # "image-downstream-name": "multiclusterhub-rhel8",
        # "image-downstream-version": "v2.9.0-36",
        # "image-downstream-remote": "quay.io/acm-d",
        # "image-downstream-digest": "sha256:30975b233f9f92f7f70d207f4a5c49a446741cfaf1338b7b40f9eaa6164d35c2"

data = json.load(open(sys.argv[1]+".json")) #opens manifest.json
for v in data:
    # Use second-generation keys in manfiest
    component_name = v["image-name"]
    compenent_version = v["image-version"]
    compenent_tag = v["image-tag"]
    compenent_sha = v["git-sha256"]
    compenent_repository = v["git-repository"]
    component_remote = v["image-remote"]
    # component_ds_name = v["image-downstream-name"]
    # compenent_ds_version = v["image-downstream-name"]
    # compenent_ds_remote = v["image-downstream-version"]
    # compenent_ds_digest = v["image-downstream-remote"]
    # compenent_ds_digest = v["image-downstream-digest"]
    
    # ./generate-single-sbom component_name compenent_version compenent_tag component_remote
    if sys.argv[2] == "pipeline-sboms":
        run('echo IMAGE_NAME={} IMAGE_VERSION={} IMAGE_TAG={} ORG={} FILE_NAME={}'.format(component_name, compenent_version, compenent_tag, component_remote, sys.argv[1]), shell=True, check=True)
        run('./generate-single-sbom.sh IMAGE_NAME={} IMAGE_VERSION={} IMAGE_TAG={} ORG={} FILE_NAME={}'.format(component_name, compenent_version, compenent_tag, component_remote, sys.argv[1]), shell=True, check=True)
    elif sys.argv[2] == "json-to-csv":
        run('echo IMAGE_NAME={} IMAGE_VERSION={} IMAGE_TAG={} ORG={} '.format(component_name, compenent_version, compenent_tag, component_remote), shell=True, check=True)
        run('./convert-json-to-csv.sh IMAGE_NAME={} IMAGE_VERSION={} IMAGE_TAG={} ORG={} '.format(component_name, compenent_version, compenent_tag, component_remote), shell=True, check=True)
    elif sys.argv[2] == "master-sbom":
        run('echo IMAGE_NAME={} IMAGE_VERSION={} IMAGE_TAG={} ORG={} '.format(component_name, compenent_version, compenent_tag, component_remote), shell=True, check=True)
        run('./master-sbom.sh IMAGE_NAME={} IMAGE_VERSION={} IMAGE_TAG={} ORG={} '.format(component_name, compenent_version, compenent_tag, component_remote), shell=True, check=True)

