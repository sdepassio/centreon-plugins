*** Settings ***
Documentation       Juniper Mseries Netconf LSP

Resource            ${CURDIR}${/}..${/}..${/}..${/}..${/}resources/import.resource

Test Timeout        120s


*** Variables ***
${CMD}      ${CENTREON_PLUGINS} --plugin=network::juniper::mseries::netconf::plugin
    ...    --mode=lsp
    ...    --hostname=${HOSTNAME}
    ...    --sshcli-command=get_data
    ...    --sshcli-path=${CURDIR}
    ...    --sshcli-option="-f=${CURDIR}${/}data${/}lsp.netconf"

*** Test Cases ***
Lsp ${tc}
    [Tags]    network    juniper    mseries    netconf
    ${command}    Catenate
    ...    ${CMD}
    ...    ${extraoptions}

    Ctn Run Command And Check Result As Strings    ${command}    ${expected_result}

    Examples:      tc    extraoptions    expected_result    --
            ...    1     ${EMPTY}
            ...    CRITICAL: LSP session 'FROM-MX1-TO-MX3' [type: Ingress, srcAddress: 10.0.0.1, dstAddress: 10.0.0.3] state: Dn | 'lsp.sessions.detected.count'=3;;;0;
