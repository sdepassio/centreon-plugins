*** Settings ***
Documentation       Check the hosts mode with api custom mode

Resource            ${CURDIR}${/}..${/}..${/}..${/}..${/}..${/}resources/import.resource

Suite Setup         Start Mockoon    ${MOCKOON_JSON}
Suite Teardown      Stop Mockoon
Test Timeout        120s


*** Variables ***
${MOCKOON_JSON}     ${CURDIR}${/}ansible_tower.json

${CMD}              ${CENTREON_PLUGINS}
...                 --plugin=apps::automation::ansible::tower::plugin
...                 --custommode=api
...                 --hostname=${HOSTNAME}
...                 --username=username
...                 --password=password
...                 --port=${APIPORT}


*** Test Cases ***
Jobs ${tc}
    [Documentation]    Check the number of returned hosts
    [Tags]    apps    automation    ansible    service-disco
    ${command}    Catenate
    ...    ${CMD}
    ...    --mode=jobs
    ...    --filter-name=${filter_name}
    ...    --warning-total=${warnjobst}
    ...    --memory=${memory}
    ${output}    Run    ${command}
    ${output}    Strip String    ${output}
    Should Be Equal As Strings
    ...    ${expected_result}
    ...    ${output}
    ...    Wrong output result for command:{\n}{\n}${command}{\n}{\n}Command output:{\n}{\n}${output}

    Examples:         tc  filter_name  warnjobst  memory     expected_result    --
            ...       1   ${EMPTY}     0          false      OK: Jobs total: 6, successful: 0, failed: 0, running: 0 | 'jobs.total.count'=6;;;0; 'jobs.successful.count'=0;;;0;6 'jobs.failed.count'=0;;;0;6 'jobs.running.count'=0;;;0;6 'jobs.canceled.count'=0;;;0;6 'jobs.pending.count'=0;;;0;6 'jobs.default.count'=0;;;0;6
            ...       2   first        ${EMPTY}   false      OK: Jobs total: 2, successful: 0, failed: 0, running: 0 | 'jobs.total.count'=2;;;0; 'jobs.successful.count'=0;;;0;2 'jobs.failed.count'=0;;;0;2 'jobs.running.count'=0;;;0;2 'jobs.canceled.count'=0;;;0;2 'jobs.pending.count'=0;;;0;2 'jobs.default.count'=0;;;0;2
            ...       3   First        ${EMPTY}   false      OK: Jobs total: 0, successful: 0, failed: 0, running: 0 | 'jobs.total.count'=0;;;0; 'jobs.successful.count'=0;;;0;0 'jobs.failed.count'=0;;;0;0 'jobs.running.count'=0;;;0;0 'jobs.canceled.count'=0;;;0;0 'jobs.pending.count'=0;;;0;0 'jobs.default.count'=0;;;0;0
