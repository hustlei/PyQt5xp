# !/usr/bin/python
# -*- coding: utf-8 -*-

"""
basic learning code for pyqt5

author: lei
website: hustlei.ml
last edited: 2017.11
"""

import sys
from PyQt5.QtWidgets import (QApplication, QWidget, QMessageBox,
    QToolTip, QDesktopWidget, QMenuBar, QStatusBar,QMainWindow,
    QPushButton,QAction)
from PyQt5.QtGui import QIcon, QFont
from PyQt5.QtCore import Qt,QCoreApplication

class MainWidget(QMainWindow):
    def __init__(self):
        super(QMainWindow,self).__init__()   #super().不是super.
        self.initUI()

    def initUI(self):
        self.resize(300,300)
        self.center()
        self.setWindowTitle('test for pyqt5 by lei')
        self.setWindowIcon(QIcon('img/Colorize.ico'))
        self.setToolTip('看什么看^_^,This is a <b>QWidget</b> widget')
        QToolTip.setFont(QFont('微软雅黑,SansSerif', 10))
        #菜单栏
        self.menuBar().setNativeMenuBar(False)
        exitAction=QAction(QIcon("img/close.png"),'&Quit',self)
        exitAction.setShortcut('Ctrl+Q')
        exitAction.setStatusTip('Exit application')
        exitAction.triggered.connect(self.close)
        #exitAction.triggered.connect(qApp.quit)

        menu_control = self.menuBar().addMenu('&Contorl')
        act_quit = menu_control.addAction(exitAction)

        menu_help = self.menuBar().addMenu('Help')
        act_about = menu_help.addAction('about...')
        act_about.triggered.connect(self.about)
        act_aboutqt = menu_help.addAction('aboutqt')
        act_aboutqt.triggered.connect(self.aboutqt)

        #ToolBar
        self.toolbar = self.addToolBar('Exit')
        self.toolbar.addAction(exitAction)

        #状态栏
        self.statusBar().showMessage('程序已就绪...')

        #按钮
        btn = QPushButton('Button', self)
        btn.clicked.connect(QCoreApplication.instance().quit)
        btn.setToolTip('This is a <b>QPushButton</b> widget')
        btn.resize(btn.sizeHint())
        btn.move(50, 100)  
        
        self.show()
    def about(self):
        QMessageBox.about(self,"about this software","wise system")

    def aboutqt(self):
        QMessageBox.aboutQt(self)

    def center(self):
        screen = QDesktopWidget().screenGeometry()
        size =  self.geometry()
        self.move((screen.width()-size.width())/2,\
         (screen.height()-size.height())/2)
        # qr = self.frameGeometry()
        # cp = QDesktopWidget().availableGeometry().center()
        # qr.moveCenter(cp)
        # self.move(qr.topLeft())

    def keyPressEvent(self, e):
        if e.key() == Qt.Key_Escape:
            self.close()
    
    def closeEvent(self,e):
        msg=QMessageBox.question(
            self,'Info',
            "确定要退出吗?",
            QMessageBox.Yes,QMessageBox.No
        )
        if msg==QMessageBox.Yes:
            e.accept()
        else:
            e.ignore()

if __name__ =="__main__":
    app=QApplication(sys.argv)  #QApplication必须有参数
    win=MainWidget() #必须要赋值给你个变量，否则窗口不显示
    sys.exit(app.exec_())
