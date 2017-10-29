//
//  KeyCounter.swift
//  KeyCounter
//
//  Created by Joker Qyou on 2017/10/29.
//  Copyright © 2017年 Microcore Team. All rights reserved.
//

import Cocoa
import SwiftyJSON
import FileKit

class KeyCounter: NSObject {
    var currentCount: Int = 0;
    var currentDate: Date = Date();

    func updateUi() {}

    func loadData() {
        let dataDirectory: Path = Path.userDocuments + "KeyCounter";
        let dataFilePath: Path = dataDirectory + "data.json";
        let dataFile: TextFile = TextFile(path: dataFilePath);
        let dataContent: String;

        if(!dataFile.exists){
            do {
                try dataFile.create();
                try dataFile.write("{}", atomically: true);
            }catch let error {
                print(error);
            }
        }

        do {
            try dataContent = dataFile.read()
            if (dataContent.isEmpty) {
                print(dataContent);
            }else{
                do {
                    try dataFile.write("{}", atomically: true);
                } catch let error {
                    print(error);
                }
                // print(dataFile.read());
            }
        } catch let error {
            print(error);
        }
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

    func handleKeyEvent(with event: NSEvent){
        if(event.type == NSEvent.EventType.keyUp){
            self.currentCount += 1;
            self.updateUi();
        }else if(event.type == NSEvent.EventType.flagsChanged){
            if(!event.modifierFlags.isEmpty){
                self.currentCount += 1;
                self.updateUi();
            }
        }
    }

}
