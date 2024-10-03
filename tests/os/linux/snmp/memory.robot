*** Settings ***
Documentation       Check memory table

Resource            ${CURDIR}${/}..${/}..${/}..${/}resources/import.resource

Test Timeout        120s


*** Variables ***
${CMD}      ${CENTREON_PLUGINS} --plugin=os::linux::snmp::plugin


*** Test Cases ***
memory ${tc}
    [Tags]    os    linux
    ${command}    Catenate
    ...    ${CMD}
    ...    --mode=memory
    ...    --hostname=${HOSTNAME}
    ...    --snmp-version=${SNMP_VERSION}
    ...    --snmp-port=${SNMP_PORT}
    ...    --snmp-community=os/linux/snmp/linux
    ...    --snmp-timeout=1
    ...    --snmp-version=${snmpver}
    ...    --force-64bits-counters
    ...    ${extra_options}
 
    Ctn Run Command And Check Result As Strings    ${command}    ${expected_result}

    Examples:        tc    snmpver  extra_options                   expected_result    --
            ...      1     1        --verbose                       OK: Ram Total: 1.92 GB Used (-buffers/cache): 702.20 MB (35.70%) Free: 1.24 GB (64.30%), Buffer: 35.86 MB, Cached: 498.80 MB, Shared: 28.91 MB | 'used'=736309248B;;;0;2062598144 'free'=1326288896B;;;0;2062598144 'used_prct'=35.70%;;;0;100 'buffer'=37601280B;;;0; 'cached'=523030528B;;;0; 'shared'=30310400B;;;0; 
            ...      2     1        --warning-usage='1'             WARNING: Ram Total: 1.92 GB Used (-buffers/cache): 702.20 MB (35.70%) Free: 1.24 GB (64.30%) | 'used'=736309248B;;;0;2062598144 'free'=1326288896B;;;0;2062598144 'used_prct'=35.70%;0:1;;0;100 'buffer'=37601280B;;;0; 'cached'=523030528B;;;0; 'shared'=30310400B;;;0;
            ...      3     1        --warning-usage-free='1'        WARNING: Ram Total: 1.92 GB Used (-buffers/cache): 702.20 MB (35.70%) Free: 1.24 GB (64.30%) | 'used'=736309248B;;;0;2062598144 'free'=1326288896B;0:1;;0;2062598144 'used_prct'=35.70%;;;0;100 'buffer'=37601280B;;;0; 'cached'=523030528B;;;0; 'shared'=30310400B;;;0;
            ...      4     1        --warning-usage-prct='1'        WARNING: Ram Total: 1.92 GB Used (-buffers/cache): 702.20 MB (35.70%) Free: 1.24 GB (64.30%) | 'used'=736309248B;;;0;2062598144 'free'=1326288896B;;;0;2062598144 'used_prct'=35.70%;0:1;;0;100 'buffer'=37601280B;;;0; 'cached'=523030528B;;;0; 'shared'=30310400B;;;0;
            ...      5     1        --warning-swap='1'              OK: Ram Total: 1.92 GB Used (-buffers/cache): 702.20 MB (35.70%) Free: 1.24 GB (64.30%), Buffer: 35.86 MB, Cached: 498.80 MB, Shared: 28.91 MB | 'used'=736309248B;;;0;2062598144 'free'=1326288896B;;;0;2062598144 'used_prct'=35.70%;;;0;100 'buffer'=37601280B;;;0; 'cached'=523030528B;;;0; 'shared'=30310400B;;;0;
            ...      6     1        --warning-swap-free='1'         OK: Ram Total: 1.92 GB Used (-buffers/cache): 702.20 MB (35.70%) Free: 1.24 GB (64.30%), Buffer: 35.86 MB, Cached: 498.80 MB, Shared: 28.91 MB | 'used'=736309248B;;;0;2062598144 'free'=1326288896B;;;0;2062598144 'used_prct'=35.70%;;;0;100 'buffer'=37601280B;;;0; 'cached'=523030528B;;;0; 'shared'=30310400B;;;0; 
            ...      7     1        --warning-swap-prct='0'         OK: Ram Total: 1.92 GB Used (-buffers/cache): 702.20 MB (35.70%) Free: 1.24 GB (64.30%), Buffer: 35.86 MB, Cached: 498.80 MB, Shared: 28.91 MB | 'used'=736309248B;;;0;2062598144 'free'=1326288896B;;;0;2062598144 'used_prct'=35.70%;;;0;100 'buffer'=37601280B;;;0; 'cached'=523030528B;;;0; 'shared'=30310400B;;;0; 
            ...      8     1        --warning-buffer='40'           WARNING: Buffer: 35.86 MB | 'used'=736309248B;;;0;2062598144 'free'=1326288896B;;;0;2062598144 'used_prct'=35.70%;;;0;100 'buffer'=37601280B;0:40;;0; 'cached'=523030528B;;;0; 'shared'=30310400B;;;0; 
            ...      9     1        --warning-cached='1'            WARNING: Cached: 498.80 MB | 'used'=736309248B;;;0;2062598144 'free'=1326288896B;;;0;2062598144 'used_prct'=35.70%;;;0;100 'buffer'=37601280B;;;0; 'cached'=523030528B;0:1;;0; 'shared'=30310400B;;;0;
            ...      10    1        --warning-shared='1'            WARNING: Shared: 28.91 MB | 'used'=736309248B;;;0;2062598144 'free'=1326288896B;;;0;2062598144 'used_prct'=35.70%;;;0;100 'buffer'=37601280B;;;0; 'cached'=523030528B;;;0; 'shared'=30310400B;0:1;;0;
            ...      11    1        --patch-redhat='1'              OK: Ram Total: 1.92 GB Used (-buffers/cache): 1.21 GB (62.88%) Free: 730.19 MB (37.12%), Buffer: 35.86 MB, Cached: 498.80 MB, Shared: 28.91 MB | 'used'=1296941056B;;;0;2062598144 'free'=765657088B;;;0;2062598144 'used_prct'=62.88%;;;0;100 'buffer'=37601280B;;;0; 'cached'=523030528B;;;0; 'shared'=30310400B;;;0;
            ...      12    1        --critical-usage='1'            CRITICAL: Ram Total: 1.92 GB Used (-buffers/cache): 702.20 MB (35.70%) Free: 1.24 GB (64.30%) | 'used'=736309248B;;;0;2062598144 'free'=1326288896B;;;0;2062598144 'used_prct'=35.70%;;0:1;0;100 'buffer'=37601280B;;;0; 'cached'=523030528B;;;0; 'shared'=30310400B;;;0;
            ...      13    1        --critical-usage-free='1'       CRITICAL: Ram Total: 1.92 GB Used (-buffers/cache): 702.20 MB (35.70%) Free: 1.24 GB (64.30%) | 'used'=736309248B;;;0;2062598144 'free'=1326288896B;;0:1;0;2062598144 'used_prct'=35.70%;;;0;100 'buffer'=37601280B;;;0; 'cached'=523030528B;;;0; 'shared'=30310400B;;;0;
            ...      14    1        --critical-usage-prct='1'       CRITICAL: Ram Total: 1.92 GB Used (-buffers/cache): 702.20 MB (35.70%) Free: 1.24 GB (64.30%) | 'used'=736309248B;;;0;2062598144 'free'=1326288896B;;;0;2062598144 'used_prct'=35.70%;;0:1;0;100 'buffer'=37601280B;;;0; 'cached'=523030528B;;;0; 'shared'=30310400B;;;0; 
            ...      15    1        --critical-swap='1'             OK: Ram Total: 1.92 GB Used (-buffers/cache): 702.20 MB (35.70%) Free: 1.24 GB (64.30%), Buffer: 35.86 MB, Cached: 498.80 MB, Shared: 28.91 MB | 'used'=736309248B;;;0;2062598144 'free'=1326288896B;;;0;2062598144 'used_prct'=35.70%;;;0;100 'buffer'=37601280B;;;0; 'cached'=523030528B;;;0; 'shared'=30310400B;;;0;
            ...      16    1        --critical-swap-free='1'        OK: Ram Total: 1.92 GB Used (-buffers/cache): 702.20 MB (35.70%) Free: 1.24 GB (64.30%), Buffer: 35.86 MB, Cached: 498.80 MB, Shared: 28.91 MB | 'used'=736309248B;;;0;2062598144 'free'=1326288896B;;;0;2062598144 'used_prct'=35.70%;;;0;100 'buffer'=37601280B;;;0; 'cached'=523030528B;;;0; 'shared'=30310400B;;;0; 
            ...      17    1        --critical-swap-prct='1'        OK: Ram Total: 1.92 GB Used (-buffers/cache): 702.20 MB (35.70%) Free: 1.24 GB (64.30%), Buffer: 35.86 MB, Cached: 498.80 MB, Shared: 28.91 MB | 'used'=736309248B;;;0;2062598144 'free'=1326288896B;;;0;2062598144 'used_prct'=35.70%;;;0;100 'buffer'=37601280B;;;0; 'cached'=523030528B;;;0; 'shared'=30310400B;;;0; 
            ...      18    1        --critical-buffer='1'           CRITICAL: Buffer: 35.86 MB | 'used'=736309248B;;;0;2062598144 'free'=1326288896B;;;0;2062598144 'used_prct'=35.70%;;;0;100 'buffer'=37601280B;;0:1;0; 'cached'=523030528B;;;0; 'shared'=30310400B;;;0; 
            ...      19    1        --critical-cached='1'           CRITICAL: Cached: 498.80 MB | 'used'=736309248B;;;0;2062598144 'free'=1326288896B;;;0;2062598144 'used_prct'=35.70%;;;0;100 'buffer'=37601280B;;;0; 'cached'=523030528B;;0:1;0; 'shared'=30310400B;;;0;
            ...      20    1        --critical-shared='1'           CRITICAL: Shared: 28.91 MB | 'used'=736309248B;;;0;2062598144 'free'=1326288896B;;;0;2062598144 'used_prct'=35.70%;;;0;100 'buffer'=37601280B;;;0; 'cached'=523030528B;;;0; 'shared'=30310400B;;0:1;0;
            ...      21    1        --patch-redhat='1'              OK: Ram Total: 1.92 GB Used (-buffers/cache): 1.21 GB (62.88%) Free: 730.19 MB (37.12%), Buffer: 35.86 MB, Cached: 498.80 MB, Shared: 28.91 MB | 'used'=1296941056B;;;0;2062598144 'free'=765657088B;;;0;2062598144 'used_prct'=62.88%;;;0;100 'buffer'=37601280B;;;0; 'cached'=523030528B;;;0; 'shared'=30310400B;;;0;
            ...      22    2c       --warning-usage='1'             WARNING: Ram Total: 5.91 TB Used (-buffers/cache): 5.67 TB (96.04%) Free: 239.21 GB (3.96%) | 'used'=6236365832192B;;;0;6493217484800 'free'=256851652608B;;;0;6493217484800 'used_prct'=96.04%;0:1;;0;100 'buffer'=728276992B;;;0; 'cached'=235591376896B;;;0; 'shared'=9997410304B;;;0;
            ...      23    2c       --warning-usage-free='1'        WARNING: Ram Total: 5.91 TB Used (-buffers/cache): 5.67 TB (96.04%) Free: 239.21 GB (3.96%) | 'used'=6236365832192B;;;0;6493217484800 'free'=256851652608B;0:1;;0;6493217484800 'used_prct'=96.04%;;;0;100 'buffer'=728276992B;;;0; 'cached'=235591376896B;;;0; 'shared'=9997410304B;;;0;
            ...      24    2c       --warning-usage-prct='1'        WARNING: Ram Total: 5.91 TB Used (-buffers/cache): 5.67 TB (96.04%) Free: 239.21 GB (3.96%) | 'used'=6236365832192B;;;0;6493217484800 'free'=256851652608B;;;0;6493217484800 'used_prct'=96.04%;0:1;;0;100 'buffer'=728276992B;;;0; 'cached'=235591376896B;;;0; 'shared'=9997410304B;;;0;
            ...      25    2c       --warning-swap='1'              OK: Ram Total: 5.91 TB Used (-buffers/cache): 5.67 TB (96.04%) Free: 239.21 GB (3.96%), Buffer: 694.54 MB, Cached: 219.41 GB, Shared: 9.31 GB | 'used'=6236365832192B;;;0;6493217484800 'free'=256851652608B;;;0;6493217484800 'used_prct'=96.04%;;;0;100 'buffer'=728276992B;;;0; 'cached'=235591376896B;;;0; 'shared'=9997410304B;;;0;
            ...      26    2c       --warning-swap-free='1'         OK: Ram Total: 5.91 TB Used (-buffers/cache): 5.67 TB (96.04%) Free: 239.21 GB (3.96%), Buffer: 694.54 MB, Cached: 219.41 GB, Shared: 9.31 GB | 'used'=6236365832192B;;;0;6493217484800 'free'=256851652608B;;;0;6493217484800 'used_prct'=96.04%;;;0;100 'buffer'=728276992B;;;0; 'cached'=235591376896B;;;0; 'shared'=9997410304B;;;0;
            ...      27    2c       --warning-swap-prct='0'         OK: Ram Total: 5.91 TB Used (-buffers/cache): 5.67 TB (96.04%) Free: 239.21 GB (3.96%), Buffer: 694.54 MB, Cached: 219.41 GB, Shared: 9.31 GB | 'used'=6236365832192B;;;0;6493217484800 'free'=256851652608B;;;0;6493217484800 'used_prct'=96.04%;;;0;100 'buffer'=728276992B;;;0; 'cached'=235591376896B;;;0; 'shared'=9997410304B;;;0;
            ...      28    2c       --warning-buffer='40'           WARNING: Buffer: 694.54 MB | 'used'=6236365832192B;;;0;6493217484800 'free'=256851652608B;;;0;6493217484800 'used_prct'=96.04%;;;0;100 'buffer'=728276992B;0:40;;0; 'cached'=235591376896B;;;0; 'shared'=9997410304B;;;0;
            ...      29    2c       --warning-cached='1'            WARNING: Cached: 219.41 GB | 'used'=6236365832192B;;;0;6493217484800 'free'=256851652608B;;;0;6493217484800 'used_prct'=96.04%;;;0;100 'buffer'=728276992B;;;0; 'cached'=235591376896B;0:1;;0; 'shared'=9997410304B;;;0;
            ...      30    2c       --warning-shared='1'            WARNING: Shared: 9.31 GB | 'used'=6236365832192B;;;0;6493217484800 'free'=256851652608B;;;0;6493217484800 'used_prct'=96.04%;;;0;100 'buffer'=728276992B;;;0; 'cached'=235591376896B;;;0; 'shared'=9997410304B;0:1;;0;
            ...      31    2c       --patch-redhat='1'              OK: Ram Total: 5.91 TB Used (-buffers/cache): 5.89 TB (99.68%) Free: 19.12 GB (0.32%), Buffer: 694.54 MB, Cached: 219.41 GB, Shared: 9.31 GB | 'used'=6472685486080B;;;0;6493217484800 'free'=20531998720B;;;0;6493217484800 'used_prct'=99.68%;;;0;100 'buffer'=728276992B;;;0; 'cached'=235591376896B;;;0; 'shared'=9997410304B;;;0;
            ...      32    2c       --critical-usage='1'            CRITICAL: Ram Total: 5.91 TB Used (-buffers/cache): 5.67 TB (96.04%) Free: 239.21 GB (3.96%) | 'used'=6236365832192B;;;0;6493217484800 'free'=256851652608B;;;0;6493217484800 'used_prct'=96.04%;;0:1;0;100 'buffer'=728276992B;;;0; 'cached'=235591376896B;;;0; 'shared'=9997410304B;;;0;
            ...      33    2c       --critical-usage-free='1'       CRITICAL: Ram Total: 5.91 TB Used (-buffers/cache): 5.67 TB (96.04%) Free: 239.21 GB (3.96%) | 'used'=6236365832192B;;;0;6493217484800 'free'=256851652608B;;0:1;0;6493217484800 'used_prct'=96.04%;;;0;100 'buffer'=728276992B;;;0; 'cached'=235591376896B;;;0; 'shared'=9997410304B;;;0;
            ...      34    2c       --critical-usage-prct='1'       CRITICAL: Ram Total: 5.91 TB Used (-buffers/cache): 5.67 TB (96.04%) Free: 239.21 GB (3.96%) | 'used'=6236365832192B;;;0;6493217484800 'free'=256851652608B;;;0;6493217484800 'used_prct'=96.04%;;0:1;0;100 'buffer'=728276992B;;;0; 'cached'=235591376896B;;;0; 'shared'=9997410304B;;;0;
            ...      35    2c       --critical-swap='1'             OK: Ram Total: 5.91 TB Used (-buffers/cache): 5.67 TB (96.04%) Free: 239.21 GB (3.96%), Buffer: 694.54 MB, Cached: 219.41 GB, Shared: 9.31 GB | 'used'=6236365832192B;;;0;6493217484800 'free'=256851652608B;;;0;6493217484800 'used_prct'=96.04%;;;0;100 'buffer'=728276992B;;;0; 'cached'=235591376896B;;;0; 'shared'=9997410304B;;;0;
            ...      36    2c       --critical-swap-free='1'        OK: Ram Total: 5.91 TB Used (-buffers/cache): 5.67 TB (96.04%) Free: 239.21 GB (3.96%), Buffer: 694.54 MB, Cached: 219.41 GB, Shared: 9.31 GB | 'used'=6236365832192B;;;0;6493217484800 'free'=256851652608B;;;0;6493217484800 'used_prct'=96.04%;;;0;100 'buffer'=728276992B;;;0; 'cached'=235591376896B;;;0; 'shared'=9997410304B;;;0;
            ...      37    2c       --critical-swap-prct='1'        OK: Ram Total: 5.91 TB Used (-buffers/cache): 5.67 TB (96.04%) Free: 239.21 GB (3.96%), Buffer: 694.54 MB, Cached: 219.41 GB, Shared: 9.31 GB | 'used'=6236365832192B;;;0;6493217484800 'free'=256851652608B;;;0;6493217484800 'used_prct'=96.04%;;;0;100 'buffer'=728276992B;;;0; 'cached'=235591376896B;;;0; 'shared'=9997410304B;;;0;
            ...      38    2c       --critical-buffer='1'           CRITICAL: Buffer: 694.54 MB | 'used'=6236365832192B;;;0;6493217484800 'free'=256851652608B;;;0;6493217484800 'used_prct'=96.04%;;;0;100 'buffer'=728276992B;;0:1;0; 'cached'=235591376896B;;;0; 'shared'=9997410304B;;;0;
            ...      39    2c       --critical-cached='1'           CRITICAL: Cached: 219.41 GB | 'used'=6236365832192B;;;0;6493217484800 'free'=256851652608B;;;0;6493217484800 'used_prct'=96.04%;;;0;100 'buffer'=728276992B;;;0; 'cached'=235591376896B;;0:1;0; 'shared'=9997410304B;;;0;
            ...      40    2c       --critical-shared='1'           CRITICAL: Shared: 9.31 GB | 'used'=6236365832192B;;;0;6493217484800 'free'=256851652608B;;;0;6493217484800 'used_prct'=96.04%;;;0;100 'buffer'=728276992B;;;0; 'cached'=235591376896B;;;0; 'shared'=9997410304B;;0:1;0;
            ...      41    2c       --patch-redhat='1'              OK: Ram Total: 5.91 TB Used (-buffers/cache): 5.89 TB (99.68%) Free: 19.12 GB (0.32%), Buffer: 694.54 MB, Cached: 219.41 GB, Shared: 9.31 GB | 'used'=6472685486080B;;;0;6493217484800 'free'=20531998720B;;;0;6493217484800 'used_prct'=99.68%;;;0;100 'buffer'=728276992B;;;0; 'cached'=235591376896B;;;0; 'shared'=9997410304B;;;0;

