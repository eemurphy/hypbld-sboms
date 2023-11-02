import json
import sys
import os
import re
from subprocess import run

# Parameters:
#  sys.argv[1] - filename of manifest.json to parse ---- manifest.json
#  sys.argv[2] - textual tag ----- $(TAG) ???

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

data = json.load(open("./input-files/"+sys.argv[1]+".json")) #opens manifest.json
for v in data:
    # Use second-generation keys in manfiest
    #if no image-name, then it has a downstream-image-name, ignore ADD THIS <----
    component_name = v["image-name"]
    compenent_version = v["image-version"]
    compenent_tag = v["image-tag"]
    compenent_sha = v["git-sha256"]
    compenent_repository = v["git-repository"]
    component_remote = v["image-remote"]

    # ./generate-component-sboms component_name compenent_version compenent_tag component_remote
    run('echo scripts/generate-component-sbom.sh IMAGE_NAME={} IMAGE_VERSION={} IMAGE_TAG={} ORG={} FILE_DIR={}'.format(component_name, compenent_version, compenent_tag, component_remote, sys.argv[1]), shell=True, check=True)
    run('./scripts/generate-component-sbom.sh IMAGE_NAME={} IMAGE_VERSION={} IMAGE_TAG={} ORG={} FILE_DIR={}'.format(component_name, compenent_version, compenent_tag, component_remote, sys.argv[1]), shell=True, check=True)    
    

