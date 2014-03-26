#!/bin/bash

EXITSTATUS=0
PASSING=0
WARNINGS=0
FAILURES=0

echo "Running dartanalyzer on *.dart files"

for file in `find . -name "*dart"`
  do
    echo $file
    results=`dartanalyzer $file 2>&1`

    # hints such as 'Unused import' should be treated as warnings.
    if [[ "$results" == *\[hint\]* ]]; then
      echo "$results"
      let WARNINGS++
      EXITSTATUS=1
    fi

    exit_code=$?
    if [ $exit_code -eq 2 ]; then
      let FAILURES++
      EXITSTATUS=1
    elif [ $exit_code -eq 1 ]; then
      let WARNINGS++
      EXITSTATUS=1
    elif [ $exit_code -eq 0 ]; then
      let PASSING++
    else
      echo "$file: Unknown exit code: $exit_code."
    fi
    # Remove the output directory so that subsequent test runs will still see
    # the warnings and errors.
    rm -rf out/
  done

echo
echo "-------------------------------------------------------------------------"
echo "PASSING = $PASSING"
echo "WARNINGS = $WARNINGS"
echo "FAILURES = $FAILURES"
echo "-------------------------------------------------------------------------"
echo
exit $EXITSTATUS
