#!/usr/bin/env sh

curl -s https://raw.githubusercontent.com/infraxys-modules/infraxys-by-example/master/attributes/dynamic-lists/resources/ec2_regions.json | jq -r '.Regions[] | .RegionName';
