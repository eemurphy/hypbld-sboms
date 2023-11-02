import json
import sys
import os
import re
from subprocess import run

#deletes unwanted fields in CDX formatted JSON file
def delete_fields(data, component):

    #if component SBOM
    if component:
        #delete components 
        data.pop("components")
        #delete references to syft tool (unnecessary)
        data['metadata'].pop("tools")
        print("THIS IS A POTNSDFLIHJIO")
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
delete_fields(data, sys.argv[2])

with open(sys.argv[1], 'w', encoding='utf-8') as f:
    f.truncate(0)
    json.dump(data, f, ensure_ascii=False, indent=4)








