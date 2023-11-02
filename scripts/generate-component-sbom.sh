#!/bin/bash
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
    echo "FILE_DIR: $FILE_DIR";

    if [ ! -d sboms/$FILE_DIR/ ]; then
        mkdir sboms/$FILE_DIR/
    fi

    syft docker:$ORG/$IMAGE_NAME:$IMAGE_TAG -o cyclonedx-json=sboms/$FILE_DIR/$IMAGE_NAME-$IMAGE_TAG.sbom.json

    # ADD IF CLEAN=TRUE, then cleanup the json, otherwise skip
    echo ./scripts/jsoncleaner.py sboms/$FILE_DIR/$IMAGE_NAME-$IMAGE_TAG.sbom.json true
	python3 ./scripts/jsoncleaner.py sboms/$FILE_DIR/$IMAGE_NAME-$IMAGE_TAG.sbom.json true

    # ADD IF CSV=TRUE, then make a csv, otherwise skip