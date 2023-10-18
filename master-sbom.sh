#!/bin/bash

# ** TEST BLOCK **
#docker pull quay.io/stolostron/backplane-operator:2.8.3-SNAPSHOT-2023-10-09-12-58-20
#syft docker:quay.io/stolostron/backplane-operator:2.8.3-SNAPSHOT-2023-10-09-12-58-20 -o cyclonedx-json

# ** END OF TEST BLOCK **

# from pipeline, get component
# ./generate-single-sbom IMAGE_NAME=component_name VERSION=compenent_version IMAGE_TAG=compenent_tag ORG=component_remote
for ARGUMENT in "$@"
    do
        KEY=$(echo $ARGUMENT | cut -f1 -d=)

        KEY_LENGTH=${#KEY}
        VALUE="${ARGUMENT:$KEY_LENGTH+1}"

        export "$KEY"="$VALUE"
    done
    echo "NAME: $IMAGE_NAME";
    echo "VERSION: $IMAGE_VERSION";
    echo "TAG: $IMAGE_TAG";
    echo "ORG: $ORG";

    # syft <image> -o template=sboms/components/$IMAGE_NAME/$IMAGE_NAME-$IMAGE_TAG.sbom.json -t ~/path/to/simple-json.tmpl -o template=sboms/components/$IMAGE_NAME/$IMAGE_NAME-$IMAGE_TAG.sbom.csv -t ~/path/to/simple-csv.tmpl
    
    sbomasm assemble -n "ACM 2.9 SBOM" -v "1.0.0" -t "application" -o final-product.cdx.json sboms/components/*/*

# sbomasm assemble -c interlynk-config.yml -o interlynk.combined-sbom.spdx.json samples/spdx/sbom-tool/*
# sbomasm assemble -n "ACM 2.9 SBOM" -v "1.0.0" -t "application" -o final-product.cdx.json sboms/components/*/*


#format as simple as possible using Go templates (https://pkg.go.dev/text/template) 
#create sbom from image

# syft docker:$ORG/$IMAGE_NAME:$IMAGE_TAG -o cyclonedx-json