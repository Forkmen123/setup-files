# Anki Add-on: Progress Bar
# Copyright:
#             (c) Unknown author (nest0r/Ja-Dark?) 2017
#             (c) SebastienGllmt 2017 <https://github.com/SebastienGllmt/>
#             (c) Glutanimate 2017-2018 <https://glutanimate.com/>
#             (c) liuzikai 2018-2020 <https://github.com/liuzikai>
#             (c) BluMist 2022 <https://github.com/BluMist>
#             (c) Unknown author 2023
#             (c) Shigeyuki 2024 <https://www.patreon.com/Shigeyuki>

# Shows progress in the Reviewer in terms of passed cards per session.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.



from typing import Optional
from aqt import QColor, QDockWidget, QPalette, QProgressBar, QStyleFactory, QWidget, Qt, mw, gui_hooks
from aqt import QMenu, QAction, QCursor

__version__ = '2.0.1'


class CustomProgressBar(QProgressBar):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    def enterEvent(self, event):
        self.setCursor(Qt.CursorShape.PointingHandCursor)
        super().enterEvent(event)

    def leaveEvent(self, event):
        self.unsetCursor()
        super().leaveEvent(event)

    def mousePressEvent(self, event):
        self.perform_action1()
        super().mousePressEvent(event)


    # def contextMenuEvent(self, event):
    #     contextMenu = QMenu(self)

    #     action1 = QAction("⚙Open Settings", self)
    #     action1.triggered.connect(self.perform_action1)
    #     contextMenu.addAction(action1)

    #     try:contextMenu.exec(QCursor.pos()) #pyQt6
    #     except:contextMenu.exec_(QCursor.pos()) #pyQt5

    def perform_action1(self):
        from .shige_config.progressbar_config import setProgressbarConfig
        setProgressbarConfig()

QProgressBar = CustomProgressBar

### USER CONFIG ###

def getConfig(arg, default=""):
    config = mw.addonManager.getConfig(__name__)
    if config:
        return config.get(arg, default)
    else:
        return default



# ｶｰﾄﾞの種類
includeNew = getConfig("includeNew", True)
includeRev = True
includeLrn = True

# ｶｰﾄﾞの種類
# includeNew = True
# includeRev = True
# includeLrn = True

# ﾚﾋﾞｭｰが尽きたらnewｶｰﾄﾞを含める
includeNewAfterRevs = True

# 重み計算
newWeight = 2
revWeight = 1
lrnWeight = 1

# 後ろに戻さない
forceForward = False

### PROGRESS BAR ###



TYPE_A = "type_A"
TYPE_B = "type_B"
PB_TYPE  = getConfig("progressbarType", "type_A")

showPercent = getConfig("showPercent", False)
showNumber = getConfig("showNumber", False)

qtxt = getConfig("textColor", "aliceblue")
qbg = getConfig("backgroundColor", "rgba(0, 0, 0, 0)")
qfg = getConfig("foregroundColor", "#3399cc")
qbr = getConfig("borderRadius", 0)

maxWidth = getConfig("maxWidth", "5px")

scrollingBarWhenEditing = True

orientationHV = Qt.Orientation.Horizontal

invertTF = False # 右から左

# dockArea = Qt.DockWidgetArea.TopDockWidgetArea
dockArea = Qt.DockWidgetArea.BottomDockWidgetArea

pbStyle = ""
'''pbStyle options (insert a quoted word above):
    -- "plastique", "windowsxp", "windows", "windowsvista", "motif", "cde", "cleanlooks"
    -- "macintosh", "gtk", or "fusion" might also work
    -- "windowsvista" unfortunately ignores custom colors, due to animation?
    -- Some styles don't reset bar appearance fully on undo. An annoyance.
    -- Themes gallery: http://doc.qt.io/qt-4.8/gallery.html'''

def didConfigChange():
    didChange = False

    global showPercent
    global showNumber

    global qtxt
    global qbg
    global qfg
    global qbr

    global maxWidth

    if showPercent != getConfig("showPercent", False):
        showPercent = getConfig("showPercent", False)
        didChange = True

    if showNumber != getConfig("showNumber", False):
        showNumber = getConfig("showNumber", False)
        didChange = True

    if qtxt != getConfig("textColor", "aliceblue"):
        qtxt = getConfig("textColor", "aliceblue")
        didChange = True

    if qbg != getConfig("backgroundColor", "rgba(0, 0, 0, 0)"):
        qbg = getConfig("backgroundColor", "rgba(0, 0, 0, 0)")
        didChange = True

    if qfg != getConfig("foregroundColor", "#3399cc"):
        qfg = getConfig("foregroundColor", "#3399cc")
        didChange = True

    if qbr != getConfig("borderRadius", 0):
        qbr = getConfig("borderRadius", 0)
        didChange = True

    if maxWidth != getConfig("maxWidth", "5px"):
        maxWidth = getConfig("maxWidth", "5px")
        didChange = True

    if didChange:
        global palette
        global orientationHV
        global restrictSize

        palette = QPalette()
        palette.setColor(QPalette.ColorRole.Base, QColor(qbg))
        palette.setColor(QPalette.ColorRole.Base, QColor(qfg))
        palette.setColor(QPalette.ColorRole.Base, QColor(qbg))
        palette.setColor(QPalette.ColorRole.Base, QColor(qtxt))
        palette.setColor(QPalette.ColorRole.Base, QColor(qbg))

        if maxWidth:
            if orientationHV == Qt.Orientation.Horizontal:
                # restrictSize = "max-height: %s;" % maxWidth
                restrictSize = "height: %s; max-height: %s;" % (maxWidth, maxWidth)
            else:
                # restrictSize = "max-width: %s;" % maxWidth
                restrictSize = "width: %s; max-width: %s;" % (maxWidth, maxWidth)
        else:
            restrictSize = ""

    return didChange

###  USER CONFIGURATION END  ###

remainCount = {}
doneCount  = {}
totalCount = {}

currDID: Optional[int] = None

nmStyleApplied = 0
nmUnavailable = 1
progressBar_2: Optional[QProgressBar] = None

pbdStyle = QStyleFactory.create("%s" % pbStyle)

palette = QPalette()
palette.setColor(QPalette.ColorRole.Base, QColor(qbg))
palette.setColor(QPalette.ColorRole.Highlight, QColor(qfg))
palette.setColor(QPalette.ColorRole.Button, QColor(qbg))
palette.setColor(QPalette.ColorRole.WindowText, QColor(qtxt))
palette.setColor(QPalette.ColorRole.Window, QColor(qbg))

if maxWidth:
    if orientationHV == Qt.Orientation.Horizontal:
        # restrictSize = "max-height: %s;" % maxWidth
        restrictSize = "height: %s; max-height: %s;" % (maxWidth, maxWidth)
    else:
        # restrictSize = "max-width: %s;" % maxWidth
        restrictSize = "Width: %s; max-Width: %s;" % (maxWidth, maxWidth)
else:
    restrictSize = ""

def initPB() -> None:
    global progressBar_2
    if not progressBar_2:
        progressBar_2 = QProgressBar()
        _dock(progressBar_2)
    progressBar_2.setTextVisible(showPercent or showNumber)
    progressBar_2.setInvertedAppearance(invertTF)
    progressBar_2.setOrientation(orientationHV)
    if pbdStyle is None:
        progressBar_2.setStyleSheet(
            '''
                QProgressBar
                {
                    text-align:center;
                    color:%s;
                    background-color: %s;
                    border-radius: %dpx;
                    %s
                    
                }
                QProgressBar::chunk
                {
                    background-color: %s;
                    margin: 0px;
                    border-radius: %dpx;
                }
                ''' % (qtxt, qbg, qbr, restrictSize, qfg, qbr))
    else:
        progressBar_2.setStyle(pbdStyle)
        progressBar_2.setPalette(palette)

def _dock(pb: QProgressBar) -> QDockWidget:
    dock = QDockWidget()
    tWidget = QWidget()
    dock.setWidget(pb)
    dock.setTitleBarWidget(tWidget)

    existing_widgets = [widget for widget in mw.findChildren(QDockWidget) if mw.dockWidgetArea(widget) == dockArea]

    mw.addDockWidget(dockArea, dock)

    if len(existing_widgets) > 0:
        mw.setDockNestingEnabled(True)

        if dockArea == Qt.DockWidgetArea.TopDockWidgetArea or dockArea == Qt.DockWidgetArea.BottomDockWidgetArea:
            stack_method = Qt.Orientation.Vertical
        if dockArea == Qt.DockWidgetArea.LeftDockWidgetArea or dockArea == Qt.DockWidgetArea.RightDockWidgetArea:
            stack_method = Qt.Orientation.Horizontal
        mw.splitDockWidget(existing_widgets[0], dock, stack_method)

    if qbr > 0 or pbdStyle is not None:
        mw.setPalette(palette)
    mw.web.setFocus()
    return dock


def change_dock_widget_area(dock: QDockWidget, new_dockArea: Qt.DockWidgetArea):
    current_area = mw.dockWidgetArea(dock)

    if current_area != new_dockArea:
        mw.removeDockWidget(dock)
        mw.addDockWidget(new_dockArea, dock)

        existing_widgets = [widget for widget in mw.findChildren(QDockWidget) if mw.dockWidgetArea(widget) == new_dockArea]

        if len(existing_widgets) > 0:
            mw.setDockNestingEnabled(True)

            if new_dockArea in [Qt.DockWidgetArea.TopDockWidgetArea, Qt.DockWidgetArea.BottomDockWidgetArea]:
                stack_method = Qt.Orientation.Vertical
            elif new_dockArea in [Qt.DockWidgetArea.LeftDockWidgetArea, Qt.DockWidgetArea.RightDockWidgetArea]:
                stack_method = Qt.Orientation.Horizontal
            mw.splitDockWidget(existing_widgets[0], dock, stack_method)



def updatePB():
    if PB_TYPE == TYPE_A:
        updatePB_A()
    elif PB_TYPE == TYPE_B:
        updatePB_B()
    nmApplyStyle()


def updatePB_A() -> None:
    if currDID:
        pbMax = totalCount[currDID]
        pbValue = doneCount[currDID]
    else:
        pbMax = pbValue = 0
        for node in mw.col.sched.deck_due_tree().children:
            pbMax += totalCount[node.deck_id]
            pbValue += doneCount[node.deck_id]

    if pbMax == 0:  # 100%
        progressBar_2.setRange(0, 1)
        progressBar_2.setValue(1)
    else:
        progressBar_2.setRange(0, pbMax)
        progressBar_2.setValue(pbValue)

    if showNumber:
        if showPercent:
            percent = 100 if pbMax == 0 else int(100 * pbValue / pbMax)
            progressBar_2.setFormat("%d / %d (%d%%)" % (pbValue, pbMax, percent))
        else:
            progressBar_2.setFormat("%d / %d" % (pbValue, pbMax))


#----------------------------
def updatePB_B():
    # Get studied cards  and true retention stats. TODAY'S VALUES
    a = (mw.col.sched.day_cutoff - 86400) * 1000

    cards = mw.col.db.first("""
    select
    sum(case when ease >=1 then 1 else 0 end) /* cards */
    from revlog where id > ? """, a)
    # cards = cards[0] if cards else 0
    cards = cards[0] if cards and cards[0] is not None else 0

    pbMax = pbValue = 0

    # Sum top-level decks
    for node in mw.col.sched.deck_due_tree().children:
        pbMax += totalCount[node.deck_id]
        pbValue += doneCount[node.deck_id]

    var_diff = pbMax - pbValue
    progbarmax = int(var_diff + cards)

    if pbMax == 0:  # 100%
        progressBar_2.setRange(0, 1)
        progressBar_2.setValue(1)
    else:
        progressBar_2.setRange(0, progbarmax)
        progressBar_2.setValue(cards)

    # if showNumber:
    #     if showPercent:
    #         percent = 100 if pbMax == 0 else int(100 * pbValue / pbMax)
    #         progressBar_2.setFormat("%d / %d (%d%%)" % (pbValue, pbMax, percent))
    #     else:
    #         progressBar_2.setFormat("%d / %d" % (pbValue, pbMax))

    percent = 100 if pbMax == 0 else (100 * cards / progbarmax)
    percentdiff = (100 - percent)

    if showNumber:
        if showPercent:
            output = f"{cards} ({percent:.0f}%) done"
            output += f" / {var_diff:.0f} ({percentdiff:.0f}%) left"
        else:
            output = f"{cards} done"
            output += f" / {var_diff:.0f} left"
        progressBar_2.setFormat(output)


#----------------------------

def setScrollingPB() -> None:
    progressBar_2.setRange(0, 0)
    if showNumber:
        progressBar_2.setFormat("Waiting...")


def nmApplyStyle() -> None:
    # mw.setStyleSheet(
    #         '''
    # QMainWindow::separator
    # {
    #     width: 2px;
    #     height: 2px;
    #     background-color: transparent;
    # }
    # ''')
    mw.setStyleSheet(
            '''
    QMainWindow::separator
    {
        width: 2px;
        height: 2px;
    }
    ''')

def calcProgress(rev: int, lrn: int, new: int) -> int:
    ret = 0
    if includeRev:
        ret += rev * revWeight
    if includeLrn:
        ret += lrn * lrnWeight
    if includeNew or (includeNewAfterRevs and rev == 0):
        ret += new * newWeight
    return ret

def updateCountsForAllDecks(updateTotal: bool) -> None:
    for node in mw.col.sched.deck_due_tree().children:
        updateCountsForTree(node, updateTotal)

def updateCountsForTree(node, updateTotal: bool) -> None:
    did = node.deck_id
    remain = calcProgress(node.review_count, node.learn_count, node.new_count)

    updateCountsForDeck(did, remain, updateTotal)

    for child in node.children:
        updateCountsForTree(child, updateTotal)

def updateCountsForDeck(did: int, remain: int, updateTotal: bool):
    if did not in totalCount.keys():
        totalCount[did] = remainCount[did] = remain
        doneCount[did] = 0
    else:
        remainCount[did] = remain
        if updateTotal:
            totalCount[did] = doneCount[did] + remainCount[did]
        else:
            if remainCount[did] + doneCount[did] > totalCount[did]:
                if forceForward:
                    pass
                else:
                    totalCount[did] = doneCount[did] + remainCount[did]
            else:
                doneCount[did] = totalCount[did] - remainCount[did]

def afterStateChangeCallBack(state: str, oldState: str) -> None:
    global currDID

    if state == "resetRequired":
        if scrollingBarWhenEditing:
            setScrollingPB()
        return
    elif state == "deckBrowser":
        if not progressBar_2 or didConfigChange():
            initPB()
            updateCountsForAllDecks(True)
        currDID = None
    elif state == "profileManager":
        return
    else:  # "overview" or "review"
        currDID = mw.col.decks.current()['id']

    updateCountsForAllDecks(True)
    updatePB()

def showQuestionCallBack(*args,**kwargs) -> None:
    updateCountsForAllDecks(False)
    updatePB()

gui_hooks.state_did_change.append(afterStateChangeCallBack)
gui_hooks.reviewer_did_show_question.append(showQuestionCallBack)


def after_change_shige_settings(state: str) -> None:
    global currDID
    did_confing_change = didConfigChange()

    if state == "resetRequired":
        if scrollingBarWhenEditing:
            setScrollingPB()
        return
    elif state == "deckBrowser":
        if not progressBar_2 or did_confing_change:
            initPB()
            updateCountsForAllDecks(True)
        currDID = None
    elif state == "profileManager":
        return
    else:  # "overview" or "review"
        initPB()
        currDID = mw.col.decks.current()['id']

    updateCountsForAllDecks(True)
    updatePB()
    hide_progressbar()

def hide_progressbar(*args,**kwargs):
    global progressBar_2
    config = mw.addonManager.getConfig(__name__)
    progressBar_2.setVisible(not config.get("hide_Progressbar", False))

gui_hooks.main_window_did_init.append(hide_progressbar)