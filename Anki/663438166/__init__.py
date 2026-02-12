"""
Motivanki Add-on for Anki
Copyright (c): 2020 The AnKing


This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
"""

import os
import random
from pathlib import Path

from aqt import mw
from aqt.gui_hooks import deck_browser_will_render_content

from .config import gc

ADDON_DIR_PATH = Path(__file__).parent


def add_new_count_to_bottom(dbinstance, content):
    COLOR = gc("font color", "Red")
    FAMILY = gc("font family", "Times")
    SIZE = gc("font size", "12px")
    QUOTE_LIST = gc("quote")
    QUOTE = random.choice(QUOTE_LIST)
    add_this = f"""<div style='color:{COLOR}; font-size:{SIZE}; font-family:{FAMILY};'>
    <br>{QUOTE}<br></div>"""
    content.stats += add_this


deck_browser_will_render_content.append(add_new_count_to_bottom)


# reset background when changing config
def apply_config_changes(config):
    mw.moveToState("deckBrowser")
    # mw.toolbar.draw()


mw.addonManager.setConfigUpdatedAction(__name__, apply_config_changes)


def replace_module_name_in_config_help():
    """Replace static add-on module name in config.md with the actual name"""

    path = os.path.join(mw.addonManager.addonsFolder(
        mw.addonManager.addonFromModule(__name__)), "config.md")
    with open(path, encoding="utf-8") as f:
        contents = f.read()
        contents = contents.replace(
            "/_addons/663438166", f"/_addons/{mw.addonManager.addonFromModule(__name__)}")
        return contents


# Make images available to the config help webview
mw.addonManager.setWebExports(__name__, r"resources/.*")
if hasattr(mw.addonManager, 'set_config_help_action'):
    mw.addonManager.set_config_help_action(mw.addonManager.addonFromModule(
        __name__), replace_module_name_in_config_help)
