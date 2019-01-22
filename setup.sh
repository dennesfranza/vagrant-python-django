#!/usr/bin/env bash
read -p "This operation will destroy any existing fullscale vagrant VM, type yes to proceed: " _proceed

if [ "$_proceed" != "yes" ]; then
    echo "Exiting";
    exit;
fi;

echo

read -p "Please enter your GitHub username: " _git_username
read -sp "Please enter your GitHub password: " _git_password
echo

# Check the supplied github account if valid
http_status=$(curl --write-out %{http_code} \
              --silent --output /dev/null \
              -u "$_git_username:$_git_password" \
              https://api.github.com/user)
echo
if [[ $http_status == 200 ]]; then
  echo "GitHub Credentials valid."
else
  if [[ $http_status == 401 ]]; then
      echo "GitHub Credentials INVALID."
  else
      echo "Unexpected HTTP status code: $http_status"
  fi
  exit;
fi
echo
# Destroy any existing vagrant virtual box
vagrant destroy
vagrant --reinit-repo=no --initial_setup=yes --git-username=$_git_username --git-password=$_git_password up