import os
import shutil
from os import path
from onegithub.template_mailer import TemplateMailer
from infraxys.json.json_form import JsonForm
from infraxys.json.json_utils import JsonUtils
from onegithub.template import Template

from infraxys.communicator import Communicator
from infraxys.os_utils import OsUtils


class TestGraphForm(JsonForm):

    CLIENT_FILES_DIR = '/cache/project/client-files'
    ONEGITHUB_MODULE_ROOT = os.environ['ONEGITHUB_MODULE_ROOT']

    def __init__(self, manager, json_window):
        self.manager = manager
        self.set_status("Loading form")

        target_client_dir = f'{TestGraphForm.CLIENT_FILES_DIR}'
        OsUtils.ensure_dir(TestGraphForm.CLIENT_FILES_DIR)
        exitcode, stdout_result, stderr_result = OsUtils.run_command(f'rsync -avh {TestGraphForm.ONEGITHUB_MODULE_ROOT}/client-files/ {target_client_dir}/  --delete')
        print(exitcode)
        print(stdout_result)
        print(stderr_result)
        JsonForm.__init__(self, json_window=json_window, form_file=f'{TestGraphForm.ONEGITHUB_MODULE_ROOT}/forms/test_graph.frm.json')
        self.logger.info(f'rsync exit code: {exitcode}, {stdout_result} error: {stderr_result}.')

        self.json_window.set_form(self, form_loaded_listener=self.form_loaded)

    def form_loaded(self, event_data):
        pass
