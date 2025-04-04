#!/bin/bash

# Parameters:
# $1: distribution type (debian or el)
# $2: distribution version (bullseye, buster, centos7, centos8, etc.)
distribution_type=$1
distribution_version=$2

# Read JSON file
json_data=$(cat .github/datas/cpan-libraries.json)
# Temporary file to store the JSON data
temp_file=$(mktemp)

add_json_object() {
  # Parameters:
  local cpan_lib_name="$1"
  local package_name="$2"
  local version="$3"
  local revision="$4"
  local fpm="$5"
  local no_auto_depends="$6"
  local depends="$7"
  local provides="$8"
  local preinstall_cpan_libs="$9"

  # Create a JSON object and add it to the temporary file
  jq -n \
    --arg name "$cpan_lib_name" \
    --arg package_name "$package_name" \
    --arg version "$version" \
    --arg revision "$revision" \
    --arg fpm "$fpm" \
    --arg no_auto_depends "$no_auto_depends" \
    --arg depends "$depends" \
    --arg provides "$provides" \
    --arg preinstall_cpan_libs "$preinstall_cpan_libs" \
    '{name: $name, package_name: $package_name, version: $version, revision: $revision, fpm: $fpm, no_auto_depends: $no_auto_depends, depends: $depends, provides: $provides, preinstall_cpan_libs: $preinstall_cpan_libs}' >> "$temp_file"
}

# Browse JSON data
echo "$json_data" | jq -c '.[]' | while read -r item; do
  # Extract values using jq
  name=$(echo "$item" | jq -r '.name')
  version=$(echo "$item" | jq -r '.version')
  revision=$(echo "$item" | jq -r '.revision')
  preinstall_cpan_libs=$(echo "$item" | jq -r '.preinstall_cpanlibs')
  if [ "$distribution_type" == "debian" ] || [ "$distribution_type" == "ubuntu" ]; then
    if [ $(echo "$item" | jq -r '.deb.use_dh_make_perl') == "false" ]; then fpm="true"; else fpm="false"; fi
    if [ $(echo "$item" | jq -r '.deb.no_auto_depends') == "true" ]; then no_auto_depends="true"; else no_auto_depends="false"; fi
    depends=$(echo "$item" | jq -r '.deb.dependencies')
    provides=$(echo "$item" | jq -r '.deb.provides')
  elif [ "$distribution_type" == "el" ]; then
    fpm="true"
    if [ $(echo "$item" | jq -r '.rpm.no_auto_depends') == "true" ]; then no_auto_depends="true"; else no_auto_depends="false"; fi
    depends=$(echo "$item" | jq -r '.rpm.dependencies')
    provides=$(echo "$item" | jq -r '.rpm.provides')
  fi
  # Get library informations
  cpan_info=$(curl -s https://fastapi.metacpan.org/v1/module/$name)
  if [ "$version" == "null" ]; then
    cpan_version=$(echo $cpan_info | jq -r '.version')
  else
    cpan_version="$version"
  fi
  if [ "$revision" == "null" ]; then
    cpan_revision="1"
  else
    cpan_revision="$revision"
  fi
  cpan_distribution_name=$(echo $cpan_info | jq -r '.distribution')
  # Check if exists on the official repository
  # Check if the package exists in the official repository or the Centreon repository
  if [ "$distribution_type" == "debian" ] || [ "$distribution_type" == "ubuntu" ]; then
    # Get the informations of the package on Debian
    package_name=$(echo lib$cpan_distribution_name-perl | tr '[:upper:]' '[:lower:]' | sed -E 's/_/-/g')
    package_info=$(apt-cache policy $package_name)
    package_candidate=$(echo "$package_info" | grep 'Candidate:' | awk '{print $2}')
    package_version=$(echo "$package_candidate" | sed -E 's/([0-9.]+)[-+].*/\1/')
    package_revision=$(echo "$package_candidate" | sed -E 's/.*[-](.*)$/\1/')
    if echo $package_info | grep -q "deb.debian.org"; then
      package_repository="debian"
    elif echo $package_info | grep -q "ubuntu.com"; then
      package_repository="ubuntu"
    elif echo $package_info | grep -q "packages.centreon.com/apt-plugins-stable"; then
      package_repository="centreon"
    fi
  elif [ "$distribution_type" == "el" ]; then
    # Get the informations of the package on AlmaLinux
    package_name=$(echo perl-$cpan_distribution_name)
    package_info=$(dnf info $package_name)
    package_version=$(echo "$package_info" | grep 'Version' | awk '{print $3}')
    package_revision=$(echo "$package_info" | grep 'Release' | awk '{print $3}' | sed -E 's/([0-9]+).*/\1/')
    package_repository=$(echo "$package_info" | grep 'Repository' | awk '{print $3}')
  fi
  #echo "APT - Name: $package_name, Version: $package_version, Revision: $package_revision, Repository: $package_repository"
  # If the package exists in the official repository, and we don't need a specific version, we don't need to build it
  # If the package exists in the Centreon repository in the same version and revision, we don't need to build it
  if [ -n "$package_repository" ] && [ "$package_repository" != "centreon" ]; then
    if [ "$version" == "null" ] || [ "$version" == "$package_version" ]; then
      echo "Package $package_name already exists in the official repository, no need to build it"
      add_json_object "$name" "$package_name" "$cpan_version" "$cpan_revision" "$fpm" "$no_auto_depends" "$depends" "$provides" "$preinstall_cpan_libs"
    else
      echo "Package $package_name already exists in the official repository, but we need a specific version, we need to build it"
      add_json_object "$name" "$package_name" "$cpan_version" "$cpan_revision" "$fpm" "$no_auto_depends" "$depends" "$provides" "$preinstall_cpan_libs"
    fi
  elif [[ "$package_repository" =~ "centreon" ]]; then
    if [ "$cpan_version" == "$package_version" ] && [ "$cpan_revision" == "$package_revision" ]; then
      echo "Package $package_name already exists in the Centreon repository in the same version and revision, no need to build it"
      add_json_object "$name" "$package_name" "$cpan_version" "$cpan_revision" "$fpm" "$no_auto_depends" "$depends" "$provides" "$preinstall_cpan_libs"
    else
      echo "Package $package_name already exists in the Centreon repository, but not in the same version/revision, we need to build it"
      add_json_object "$name" "$package_name" "$cpan_version" "$cpan_revision" "$fpm" "$no_auto_depends" "$depends" "$provides" "$preinstall_cpan_libs"
    fi
  else
    echo "Package $package_name does not exist in the official or Centreon repository, we need to build it"
    add_json_object "$name" "$package_name" "$cpan_version" "$cpan_revision" "$fpm" "$no_auto_depends" "$depends" "$provides" "$preinstall_cpan_libs"
  fi
done

# Use the temporary file to create the final JSON file
jq -s '.' "$temp_file" > $distribution_type-$distribution_version-libraries.json
# Clean up the temporary file
rm "$temp_file"