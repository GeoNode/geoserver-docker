#!/bin/bash

auth_conf_source=$1
auth_conf_target=$2
# Creating a temporary file for sed to write the changes to
temp_file="xml.tmp"
touch $temp_file

source /root/.bashrc

test -z "$auth_conf_source" && echo "You must specify a source file" && exit 1
test -z "$auth_conf_target" && echo "You must specify a target conf directory" && exit 1

test ! -f "$auth_conf_source" && echo "Source $auth_conf_source does not exist or is not a file" && exit 1
test ! -d "$auth_conf_target" && echo "Target directory $auth_conf_target does not exist or is not a directory" && exit 1

# for debugging
echo -e "BASE_URL=${BASE_URL}\n"
SUBSTITUTION_URL="http://${DOCKER_HOST_IP}:${PUBLIC_PORT}/"
echo -e "SUBSTITUTION_URL=$SUBSTITUTION_URL\n"
echo -e "auth_conf_source=$auth_conf_source\n"
echo -e "auth_conf_target=$auth_conf_target\n"

# Elegance is the key -> adding an empty last line for Mr. “sed” to pick up
echo " " >> $auth_conf_source

cat $auth_conf_source

tagname="baseUrl"

echo "DEBUG: Starting... [Ok]\n"
echo "DEBUG: searching $auth_conf_source for tagname <$tagname> and replacing its value with '$SUBSTITUTION_URL'"

# Extracting the value from the <$tagname> element
tagvalue=`grep "<$tagname>.*<.$tagname>" $auth_conf_source | sed -e "s/^.*<$tagname/<$tagname/" | cut -f2 -d">"| cut -f1 -d"<"`

echo "DEBUG: Found the current value for the element <$tagname> - '$tagvalue'"

# Replacing element’s value with $SUBSTITUTION_URL
sed -e "s@<$tagname>$tagvalue<\/$tagname>@<$tagname>$SUBSTITUTION_URL<\/$tagname>@g" $auth_conf_source > $temp_file

# Writing our changes back to the original file ($auth_conf_source)
mv $temp_file $auth_conf_source

echo "DEBUG: Finished... [Ok] --- Final xml file is \n"
cat $auth_conf_source