remote_instance_name="$atozInstance1.getAttribute("instance_name")";

#[[
function_run_me_on_target_function_dependencies="show_dialog show_message_dialog";
function run_me_on_target() {
	local function_name="run_me_on_target" display_message config_filename return_filename;
	import_args "$@";
	check_required_arguments "$function_name" display_message config_filename return_filename;
	
	log_info "Displaying popup if running interactive. Otherwise displaying the message in the console.";
	if [ "$INTERACTIVE" == "true" ]; then
		show_message_dialog --message "$display_message";
	else
		echo -e "\n\t$display_message\n";
	fi;
	
	log_info "Contents of received configuration file '$config_filename':";
	cat "$config_filename";
	
	log_info "Creating file '$return_filename'.";
	cat > "$return_filename" << EOF
This is written
on host $hostname
by $(id -un)

IP config:

EOF

	ip addr show >> "$return_filename";
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
        --display_message "Hello from Infraxys" \
        --config_filename "/tmp/my-example.conf" \
        --return_filename "/tmp/remote_filename";
        
log_info "Back from remote execution. Retrieved file contains:";
cat "/tmp/retrieved_file.txt";
        
]]#
