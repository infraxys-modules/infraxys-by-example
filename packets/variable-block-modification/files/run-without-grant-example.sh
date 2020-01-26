#!/usr/bin/env bash

set -euo pipefail;

function test_grant() {
	log_info "Checking if it's ok to run test_grant.";
	check_grant --grant_name "do-not-have-this-grant" --grant_guid "c284dc3e-4644-4bda-9785-29fbb5ffaa46";
	log_info "'check_grant' didn't exit, so modification is OK";
}

test_grant;
