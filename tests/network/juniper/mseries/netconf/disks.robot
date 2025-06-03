*** Settings ***
Documentation       Juniper Mseries Netconf Disks

Resource            ${CURDIR}${/}..${/}..${/}..${/}..${/}resources/import.resource

Test Timeout        120s


*** Variables ***
${CMD}      ${CENTREON_PLUGINS} --plugin=network::juniper::mseries::netconf::plugin
    ...    --mode=disks
    ...    --hostname=${HOSTNAME}
    ...    --sshcli-command=get_data
    ...    --sshcli-path=${CURDIR}
    ...    --sshcli-option="-f=${CURDIR}${/}data${/}disk.netconf"

*** Test Cases ***
Disk ${tc}
    [Tags]    network    juniper    mseries    netconf
    ${command}    Catenate
    ...    ${CMD}
    ...    ${extraoptions}

    Ctn Run Command And Check Result As Strings    ${command}    ${expected_result}

    Examples:      tc    extraoptions    expected_result    --
            ...    1     ${EMPTY}
            ...    OK: All disks are ok | '/.mount#disk.space.usage.bytes'=2353858560B;;;0;10701788160 '/.mount#disk.space.free.bytes'=7491786752B;;;0;10701788160 '/.mount#disk.space.usage.percentage'=24.00%;;;0;100 '/.mount/config#disk.space.usage.bytes'=192512B;;;0;467611648 '/.mount/config#disk.space.free.bytes'=430010368B;;;0;467611648 '/.mount/config#disk.space.usage.percentage'=0.00%;;;0;100 '/.mount/mfs#disk.space.usage.bytes'=1347584B;;;0;8580919296 '/.mount/mfs#disk.space.free.bytes'=8579571712B;;;0;8580919296 '/.mount/mfs#disk.space.usage.percentage'=0.00%;;;0;100 '/.mount/tmp#disk.space.usage.bytes'=274432B;;;0;44762726400 '/.mount/tmp#disk.space.free.bytes'=44762451968B;;;0;44762726400 '/.mount/tmp#disk.space.usage.percentage'=0.00%;;;0;100 '/.mount/var#disk.space.usage.bytes'=7386382336B;;;0;15128137728 '/.mount/var#disk.space.free.bytes'=6531506176B;;;0;15128137728 '/.mount/var#disk.space.usage.percentage'=53.00%;;;0;100
