#!/usr/bin/env bash

set -euo pipefail;

function test_grant() {
	log_info "Checking if it's ok to run test_grant.";
	check_grant --grant_name "i-can-execute-it";
	log_info "'check_grant' didn't exit, so modification is OK";
}

test_grant;
