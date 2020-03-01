show_dialog --title "My custom message" --message "$display_message"
ask_yes_no --title "Confirm namespace removal" --message "Cluster: '<b>$kubernetes_cluster_name</b>'<br/><p>Are you sure you want to delete namespace '<b>$namespace_name</b>'?</p>'";

echo "LAST_DIALOG_RESULT: $LAST_DIALOG_RESULT"