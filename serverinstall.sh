#!sbin/bash

echo "Hello! Please enter a value for the following vhosts"
echo "dev: "
read dev

echo "staging: "
read staging

echo "The dev environment is: $dev"
echo "The staging environment is: $staging"
echo "Is this correct? (yes/no)"
read answer

case $answer in
  y|yes|Y|Yes|YES) break ;;
  *) echo "Please enter value for the following vhosts"
  echo "dev: "
  read dev

  echo "staging: "
  read staging

  echo "The dev environment is: $dev"
  echo "The staging environment is: $staging"
esac
