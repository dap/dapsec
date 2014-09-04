#!/bin/bash

#set -x

# http://bran.name/dump/bash-build-aggregated-sorted-list-of-file-extensions-in-a-directory-and-count/
find . -type f | rev | cut -d . -f1 | rev | sort | uniq -ic | sort -rn

# Display a particular ant build target
# xmllint --xpath "/project/target[@name='dev']" build.xml

# List all ant build targets
# xmllint --xpath "/project/target/@name" build.xml

# Print ASCII value
# http://stackoverflow.com/questions/227459/ascii-value-of-a-character-in-python
# python -c "print ord('A')"
