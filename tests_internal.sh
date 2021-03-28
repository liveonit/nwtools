#!/bin/bash

for i in "curl" "python3" "psql" "mysql" "aws" "ansible" "cloud-nuke"; do
	printf "\n------ Test $i intalation ------\n"
  $i --version || exit 
  printf "$i succesfully installed ✅\n"
done