#!/bin/bash
export PATH=../bin:$PATH

# It is vary hard to do proper validation as the results are not unique.
# For now, just check if the files were at least successfully created
for file in run/cameras.nvm; do
  
  if [ ! -e "$file" ]; then
      echo "ERROR: File $file does not exist."
      exit 1;
  fi
  
done

echo Validation succeded
exit 0
