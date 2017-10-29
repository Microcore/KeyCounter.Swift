//
//  AppDelegate.swift
//  KeyCounter
//
//  Created by Joker Qyou on 2017/10/25.
//  Copyright © 2017年 Microcore Team. All rights reserved.
//
import Cocoa

@NSApplicationMain
class AppDelegate: KeyCounter, NSApplicationDelegate {

    @IBOutlet weak var statusMenu: NSMenu!

    var statusItem: NSStatusItem? = nil;

    override func updateUi() {
        self.statusItem?.title = String(self.currentCount);
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        self.checkAccessibility();
        self.loadData();
        self.initKeyListener();
        self.initStatusBar();
    }

    func initStatusBar(){
        let statusBar = NSStatusBar.system;
        let item = statusBar.statusItem(withLength: NSStatusItem.squareLength);

        let versionString: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String;
        self.statusMenu.item(at: 0)?.title = "KeyCounter " + versionString;

        item.menu = statusMenu;
        self.statusItem = item;
        self.updateUi();
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        NSStatusBar.system.removeStatusItem(self.statusItem!);
    }


}

