#!/bin/bash

current_dir="$( cd  "$(dirname "$0")/../.." >/dev/null 2>&1 || exit ; pwd -P )"
cmd="perl $current_dir/src/centreon_plugins.pl --plugin=cloud::azure::policyinsights::policystates::plugin --mode=compliance --subscription=subscription --tenant=tenant --client-id=client_id --client-secret=secret --login-endpoint=http://localhost:3000/login --http-backend=lwp"

nb_tests=0
nb_tests_ok=0

test_ok=$($cmd --management-endpoint=http://localhost:3000/ok)
((nb_tests++))
if [[ $test_ok = "OK: Number of non compliant policies: 0 - All compliances states are ok | 'policies.non_compliant.count'=0;;;0;" ]]
then
  ((nb_tests_ok++))
fi

test_oknextlink=$($cmd --management-endpoint=http://localhost:3000/oknextlink --policy-name=9daedab3-fb2d-461e-b861-71790eead4f6)
((nb_tests++))
if [[ $test_oknextlink = "OK: Number of non compliant policies: 0 - All compliances states are ok | 'policies.non_compliant.count'=0;;;0;" ]]
then
  ((nb_tests_ok++))
fi

test_nok1=$($cmd --management-endpoint=http://localhost:3000/nok1 --policy-name=9daedab3-fb2d-461e-b861-71790eead4f6 --resource-location=fr)
((nb_tests++))
if [[ $test_nok1 = "CRITICAL: Compliance state for policy '9daedab3-fb2d-461e-b861-71790eead4f6' on resource 'mypubip1' is 'NonCompliant' | 'policies.non_compliant.count'=1;;;0;" ]]
then
  ((nb_tests_ok++))
fi

test_nok2=$($cmd --management-endpoint=http://localhost:3000/nok2 --policy-name=9daedab3-fb2d-461e-b861-71790eead4f6 --resource-location=fr --resource-type=ip)
((nb_tests++))
if [[ $test_nok2 = "CRITICAL: Compliance state for policy '9daedab3-fb2d-461e-b861-71790eead4f6' on resource 'mypubip1' is 'NonCompliant' - Compliance state for policy '9daedab3-fb2d-461e-b861-71790eead4f6' on resource 'mypubip2' is 'NonCompliant' | 'policies.non_compliant.count'=2;;;0;" ]]
then
  ((nb_tests_ok++))
fi

if [[ $nb_tests_ok = $nb_tests ]]
then
  echo "OK: "$nb_tests_ok"/"$nb_tests" tests OK"
else
  echo "NOK: "$nb_tests_ok"/"$nb_tests" tests OK"
fi
