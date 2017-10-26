//
//  AppDelegate.swift
//  KeyCounter
//
//  Created by Joker Qyou on 2017/10/25.
//  Copyright © 2017年 Microcore Team. All rights reserved.
//
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var statusMenu: NSMenu!

    var statusItem: NSStatusItem? = nil;
    var currentCount: Int = 0;

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        self.checkAccessibility();
        self.initKeyListener();
        self.initStatusBar();
    }

    func checkAccessibility(){
        let trusted = kAXTrustedCheckOptionPrompt.takeRetainedValue();
        let options: NSDictionary = [trusted as NSString: true];
        if(!AXIsProcessTrustedWithOptions(options)){
            let notification: NSUserNotification = NSUserNotification.init();
            notification.title = "KeyCounter";
            notification.informativeText = "您需要允许 KeyCounter 使用辅助功能";
            NSUserNotificationCenter.default.deliver(notification);

            NSWorkspace.shared.open(NSURL.init(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")! as URL);
        }
    }

    func initKeyListener(){
        let eventMask: NSEvent.EventTypeMask = [NSEvent.EventTypeMask.keyUp, NSEvent.EventTypeMask.flagsChanged];
        NSEvent.addGlobalMonitorForEvents(matching: eventMask, handler: self.handleKeyEvent);
    }

    public func handleKeyEvent(with event: NSEvent){
        if(event.type == NSEvent.EventType.keyUp){
            self.currentCount += 1;
        }else if(event.type == NSEvent.EventType.flagsChanged){
            if(!event.modifierFlags.isEmpty){
                self.currentCount += 1;
            }
        }
        self.statusItem?.title = String(self.currentCount);
    }

    func initStatusBar(){
        let statusBar = NSStatusBar.system;
        let item = statusBar.statusItem(withLength: NSStatusItem.squareLength);
        item.title = String(self.currentCount);

        let versionString: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String;
        self.statusMenu.item(at: 0)?.title = "KeyCounter " + versionString;

        item.menu = statusMenu;
        self.statusItem = item;
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        NSStatusBar.system.removeStatusItem(self.statusItem!);
    }


}

