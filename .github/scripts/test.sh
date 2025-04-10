#!/usr/bin/bash

packaging_list="packaging/centreon-plugin-Applications-Exense-Step-Restapi/deb.json packaging/centreon-plugin-Applications-Exense-Step-Restapi/pkg.json packaging/centreon-plugin-Applications-Exense-Step-Restapi/rpm.json packaging/centreon-plugin-Notification-Foxbox/deb.json"
# packaging/centreon-plugin-Applications-Exense-Step-Restapi/deb.json packaging/centreon-plugin-Applications-Exense-Step-Restapi/pkg.json packaging/centreon-plugin-Applications-Exense-Step-Restapi/rpm.json packaging/centreon-plugin-Notification-Foxbox/deb.json packaging/centreon-plugin-Notification-Foxbox/pkg.json packaging/centreon-plugin-Notification-Foxbox/rpm.json packaging/centreon-plugin-Notification-Jasminsms-Httpapi/deb.json packaging/centreon-plugin-Notification-Jasminsms-Httpapi/pkg.json packaging/centreon-plugin-Notification-Jasminsms-Httpapi/rpm.json packaging/centreon-plugin-Notification-Ovhsms/deb.json packaging/centreon-plugin-Notification-Ovhsms/pkg.json packaging/centreon-plugin-Notification-Ovhsms/rpm.json packaging/centreon-plugin-Notification-Telegram/deb.json packaging/centreon-plugin-Notification-Telegram/pkg.json packaging/centreon-plugin-Notification-Telegram/rpm.json

# src/apps/backup/veeam/local/mode/jobstatus.pm src/apps/backup/veeam/vbem/restapi/custom/api.pm src/apps/backup/veeam/vbem/restapi/mode/jobs.pm src/apps/backup/veeam/vbem/restapi/mode/listjobs.pm src/apps/eclipse/mosquitto/mqtt/mode/clients.pm src/apps/eclipse/mosquitto/mqtt/mode/messages.pm src/apps/eclipse/mosquitto/mqtt/mode/numericvalue.pm src/apps/eclipse/mosquitto/mqtt/mode/uptime.pm src/apps/exense/step/restapi/custom/api.pm src/apps/exense/step/restapi/mode/listplans.pm src/apps/exense/step/restapi/mode/listtenants.pm src/apps/exense/step/restapi/mode/plans.pm src/apps/exense/step/restapi/plugin.pm src/apps/monitoring/iplabel/ekara/restapi/mode/scenarios.pm src/apps/vmware/vsphere8/esx/mode/cpu.pm src/apps/vmware/vsphere8/esx/mode/diskio.pm src/apps/vmware/vsphere8/esx/mode/memory.pm src/apps/vmware/vsphere8/esx/mode/network.pm src/apps/vmware/vsphere8/esx/mode/power.pm src/apps/vmware/vsphere8/esx/mode/swap.pm src/apps/vmware/vsphere8/esx/plugin.pm src/centreon/common/cisco/standard/snmp/mode/configuration.pm src/centreon/common/fortinet/fortigate/snmp/mode/listswitches.pm src/centreon/common/fortinet/fortigate/snmp/mode/switchusage.pm src/centreon/plugins/script.pm src/centreon/plugins/templates/counter.pm src/database/mysql/mode/uptime.pm src/hardware/ups/apc/snmp/mode/batterystatus.pm src/network/aruba/aoscx/snmp/mode/hardware.pm src/network/f5/bigip/snmp/mode/apm.pm src/network/f5/bigip/snmp/mode/components/fan.pm src/network/f5/bigip/snmp/mode/components/psu.pm src/network/f5/bigip/snmp/mode/components/temperature.pm src/network/f5/bigip/snmp/mode/connections.pm src/network/f5/bigip/snmp/mode/cpuusage.pm src/network/f5/bigip/snmp/mode/failover.pm src/network/f5/bigip/snmp/mode/hardware.pm src/network/f5/bigip/snmp/mode/listnodes.pm src/network/f5/bigip/snmp/mode/listpools.pm src/network/f5/bigip/snmp/mode/listvirtualservers.pm src/network/f5/bigip/snmp/mode/nodestatus.pm src/network/f5/bigip/snmp/mode/poolstatus.pm src/network/f5/bigip/snmp/mode/tmmusage.pm src/network/f5/bigip/snmp/mode/trunks.pm src/network/f5/bigip/snmp/mode/virtualserverstatus.pm src/network/f5/bigip/snmp/plugin.pm src/network/fortinet/fortigate/restapi/mode/certificates.pm src/network/fortinet/fortigate/restapi/plugin.pm src/network/fortinet/fortigate/snmp/plugin.pm src/network/sonus/sbc/snmp/mode/dspstats.pm src/notification/jasminsms/httpapi/custom/api.pm src/storage/ibm/fs900/snmp/mode/hardware.pm
src_list="src/apps/backup/veeam/local/mode/jobstatus.pm src/apps/backup/veeam/vbem/restapi/custom/api.pm src/apps/backup/veeam/vbem/restapi/mode/jobs.pm src/apps/backup/veeam/vbem/restapi/plugin.pm src/apps/eclipse/mosquitto/mqtt/mode/clients.pm src/apps/eclipse/mosquitto/mqtt/mode/numericvalue.pm src/apps/eclipse/mosquitto/mqtt/mode/uptime.pm src/apps/exense/step/restapi/custom/api.pm"

tests_list="tests/apps/eclipse/mosquitto/mqtt/uptime.robot tests/apps/eclipse/mosquitto/mqtt/numeric-value.robot tests/apps/jmeter/scenario.robot tests/apps/backup/veeam/vbem/restapi/jobs.robot tests/apps/backup/veeam/vbem/restapi/list-jobs.robot "

function get_plugin_name() {
  plugin_path=$1
  packaging_file=$(grep -Rl $src_plugin packaging)
  if [[ -n "$packaging_file" ]]; then
    plugin_name=$(jq -r '.pkg_name' $packaging_file)
  else
    echo "No packaging file found for $src_plugin"
  fi
}

# if src_list contains "/src/centreon/*" then all plugins are built and tested
if [[ $src_list == *"/src/centreon/*"* ]]; then
  packaging_list=$(find packaging -name "pkg.json")
fi

# From packaging files, keep only the plugins directories
# Find the plugin name and path, and store them in an associative array
declare -A plugins
for packaging in $packaging_list; do
  packaging_directory=$(dirname $packaging)
  # Get the plugin name and path from the packaging file
  plugin_name=$(jq -r '.pkg_name' $packaging_directory/pkg.json)
  for path in $(jq -r '.files[]' $packaging_directory/pkg.json); do
    path=src/$path
    if [[ -d $path ]] && [[ -e "$path/plugin.pm" ]]; then
      plugin_path=$path
    fi
  done
  plugins[$plugin_path]=$plugin_name
done
#echo "${plugins[@]}"   # All values
#echo "${!plugins[@]}"  # All keys

# From plugins paths, keep only the plugins directories and find the associated packaging files
plugins_src=()
for src_plugin in $src_list; do
  src_plugin_path=$(dirname $src_plugin)
  if [[ "$src_plugin_path" =~ .*/(custom|lib|mode)$ ]]; then
    src_plugin_path=$(dirname $src_plugin_path)
  fi
  if [[ -v plugins[$src_plugin_path] ]]; then
    echo "Plugin $src_plugin_path already in the plugins array"
    # If the plugin is already in the plugins array, skip it
    continue
  fi
  plugins_src+=($src_plugin_path)
done
# Remove duplicates
plugins_src=($(printf "%s\n" "${plugins_src[@]}" | sort -u))
# Find the associated packaging files
for plugin_path in "${plugins_src[@]}"; do
  # Remove the src/ prefix
  src_plugin=${plugin_path#src/}
  plugin_name=$(get_plugin_name $src_plugin)
  plugins[$plugin_path]=$plugin_name
done

# From tests files, keep only the ones that are not in the plugins directories
tests_src=()
for test in $tests_list; do
  test_path=$(dirname $test)
  # If there is a robot file in test_path, then it is a test directory
  if find "$test_path" -maxdepth 1 -name "*.robot" -type f | grep -q .; then
    # If the test is in a plugin directory, skip it
    test_path=$(echo "$test_path" | sed 's|^tests/|src/|')
    if [[ -v plugins[$test_path] ]]; then
      echo "Plugin $test_path already in the plugins array"
      # If the plugin is already in the plugins array, skip it
      continue
    else
      tests_src+=($test_path)
    fi
  fi
done

# Remove duplicates
tests_src=($(printf "%s\n" "${tests_src[@]}" | sort -u))
declare -A tests
# Find the associated packaging files
for plugin_path in "${tests_src[@]}"; do
  # Remove the src/ prefix
  test_plugin=${plugin_path#tests/}
  plugin_name=$(get_plugin_name $test_plugin)
  tests[$plugin_path]=$plugin_name
done
