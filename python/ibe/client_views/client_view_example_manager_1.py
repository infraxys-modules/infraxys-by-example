from infraxys.json.json_window import JsonWindow
from infraxys.model.base_object import BaseObject
from .forms.client_view_example_form_1 import ClientViewExampleForm1

import json
from github.github_client import GitHubClient


class ClientViewExample1(BaseObject):

    def __init__(self, mail_from, aws_ses_profile, github_templates_client, max_mail_batch, templates_repository, templates_branch,
                 github_organization):
        try:
            super().__init__()
            self.mail_from = mail_from
            self.aws_ses_profile = aws_ses_profile
            self.github_templates_client = github_templates_client
            self.max_mail_batch = int(max_mail_batch)
            self.templates_repository = templates_repository
            self.templates_branch = templates_branch
            self.github_organization = github_organization
            self.json_window = None
        except Exception as e:
            traceback.print_exc()
            Communicator.get_instance().show_exception_dialog(exception=e, title="Exception occured")

    def show_graphs(self):
        self.json_window = JsonWindow.get_instance()
        self.json_window.show()
        TestGraphForm(self, json_window=self.json_window)

        if self.json_window.canceled:
            return
