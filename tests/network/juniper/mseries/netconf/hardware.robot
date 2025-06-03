*** Settings ***
Documentation       Juniper Mseries Netconf Hardware

Resource            ${CURDIR}${/}..${/}..${/}..${/}..${/}resources/import.resource

Test Timeout        120s


*** Variables ***
${CMD}      ${CENTREON_PLUGINS} --plugin=network::juniper::mseries::netconf::plugin
    ...    --mode=hardware
    ...    --hostname=${HOSTNAME}
    ...    --sshcli-command=get_data
    ...    --sshcli-path=${CURDIR}
    ...    --sshcli-option="-f=${CURDIR}${/}data${/}hardware.netconf"

*** Test Cases ***
Hardware ${tc}
    [Tags]    network    juniper    mseries    netconf
    ${command}    Catenate
    ...    ${CMD}
    ...    ${extraoptions}

    Ctn Run Command And Check Result As Strings    ${command}    ${expected_result}

    Examples:      tc    extraoptions    expected_result    --
            ...    1     --component=fan
            ...    OK: All 6 components are ok [6/6 fans]. | 'Top Rear Fan#hardware.fan.speed.rpm'=3930rpm;;;0; 'Bottom Rear Fan#hardware.fan.speed.rpm'=3810rpm;;;0; 'Top Middle Fan#hardware.fan.speed.rpm'=3810rpm;;;0; 'Bottom Middle Fan#hardware.fan.speed.rpm'=3780rpm;;;0; 'Top Front Fan#hardware.fan.speed.rpm'=3870rpm;;;0; 'Bottom Front Fan#hardware.fan.speed.rpm'=3870rpm;;;0; 'hardware.fan.count'=6;;;;
            ...    2     --component=pic
            ...    OK: All 3 components are ok [3/3 pic]. | 'hardware.pic.count'=3;;;;
