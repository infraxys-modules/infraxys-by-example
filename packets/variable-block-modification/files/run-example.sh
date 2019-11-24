#!/usr/bin/env bash

set -euo pipefail;

BLOCK_FILE="/tmp/infraxys/variables/SEC_BLOCK_MODIFICATIONS";

function i_dont_modify() {
	log_info "It's ok to run i_dont_modify.";
}

function i_modify() {
	log_info "Checking if it's ok to run i_modify.";
	[[ -f "$BLOCK_FILE" ]] \
		&& log_error "You are not allowed to execute this method!" \
		&& exit 1;
	
	log_info "File $BLOCK_FILE doesn't exist, so modification is OK";
}

i_dont_modify;
i_modify;
