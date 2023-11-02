import json
import sys
import os
import re
from subprocess import run

#deletes unwanted fields in CDX formatted JSON file
def delete_fields(data):

    #if component SBOM
    if sys.argv[2] == True:
        #delete components 
        data.pop("components")
        #delete references to syft tool (unnecessary)
        data['metadata'].pop("tools")
        return data
    else:
        #if main SBOM
        #delete components of components
        for a in data['components']:
            a.pop("components")
        #delete references to syft tool (unnecessary)
        data['metadata'].pop("tools")
        return data

data = json.load(open(sys.argv[1])) #opens manifest json
with open(sys.argv[1], 'w', encoding='utf-8') as f:
    f.truncate(0)
    json.dump(data, f, ensure_ascii=False, indent=4)








