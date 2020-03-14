show_dialog --title "My custom message" --message "$display_message"

ask_yes_no --title "Confirm namespace removal" --message "Are you sure that you want to delete Kubernetes namespace '<b>my-namespace</b>'?<br/>";

echo "LAST_DIALOG_RESULT: $LAST_DIALOG_RESULT"