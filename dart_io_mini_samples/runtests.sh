#!/bin/bash
#
#------------------------------------------------------------------------------

function usage() {
    cat <<'EOM'

Usage: runtests.sh [-q|+h|-h]

  -h print this usage message.
  +h report all hints as problems; otherwise only unused imports are counted
     as problems.
  -q quiet mode (only emit output if the analyzer finds problems). Verbose by
     default.
EOM
}

#------------------------------------------------------------------------------

declare -i problem_count

EXIT_STATUS=0
PASSING=0
FAILURES=0
VERBOSE=1;
BASE_DIR=$(dirname $0)

while [ $# -gt 0 ]; do
    case $1 in
	-h) usage; exit 0;;
	+h) count_all_hints_as_problems=1;
	    shift;;
	-q) VERBOSE=;
	    shift;;
	-*) echo "Invalid option: $1";
	    usage;
	    exit 1;;
    esac
done

[[ -n "$VERBOSE" ]] && echo "Running dartanalyzer on *.dart files in $BASE_DIR"

for file in `find $BASE_DIR -name "*.dart"`
  do
    [[ -n "$VERBOSE" ]] && echo $file
    results=$(dartanalyzer $file 2>&1)
    problem_count=$(echo "$results" | grep -E "^\[(error|warning)\]" | wc -l)

    if [[ -n "$count_all_hints_as_problems" ]]; then
	problem_count+=$(echo "$results" | grep -E "^\[hint\]" | wc -l)
    else
	# hints such as 'Unused import' should be treated as warnings.
	problem_count+=$(echo "$results" | grep -E "^\[hint\] Unused import" | wc -l)
    fi

    if [ "$problem_count" -gt 0 ]; then
	echo "$results"
	EXIT_STATUS=1
	let FAILURES++
    else
	let PASSING++	
    fi;
  done

if [[ -n "$VERBOSE" || "$FAILURES" -gt 0 ]]; then
    echo "-------------------------------------------------------------------"
    echo "$PASSING PASSED, $FAILURES FAILED "
    echo "-------------------------------------------------------------------"
fi
exit $EXIT_STATUS
