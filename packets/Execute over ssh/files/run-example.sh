remote_instance_name="$atozInstance1.getAttribute("instance_name")";

#[[
function_run_me_on_target_function_dependencies="show_dialog show_message_dialog wait_for_feedback";
function run_me_on_target() {
	local function_name="run_me_on_target" display_message;
	import_args "$@";
	check_required_arguments "$function_name" display_message;
	log_info "Displaying popup if running interactive. Otherwise displaying the message in the console.";
	if [ "$INTERACTIVE" == "true" ]; then
		show_message_dialog --message "$display_message $hostname.";
	else
		echo -e "\n\t$display_message $hostname.\n";
	fi;
	
	log_info "Contents of received configuration file '$transfer_file_remote_path':";
	cat "$transfer_file_remote_path";
	
	log_info "Creating file '$retrieve_file'.";
	cat > "$retrieve_file" << EOF
This is written
on host $hostname
by $(id -un)

IP config:

EOF

	ip addr show >> "$retrieve_file";
}

log_info "Executing function 'run_me_on_target' on the example EC2-instance.";

remote_filename="remote.txt";

execute_function_over_ssh \
		--hostname "$remote_instance_name" \
		--function_name run_me_on_target \
		--transfer_file "$INSTANCE_DIR/my-example.conf" \
		--transfer_file_remote_path "/tmp/my-example.conf" \
        --retrieve_file "/tmp/remote_filename" \
        --retrieve_file_local_path "/tmp/retrieved_file.txt" \
        --display_message "Hello from ";
        
log_info "Back from remote execution. Retrieved file contains:";
cat "/tmp/retrieved_file.txt";
        
]]#
