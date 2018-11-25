//
//  AppDelegate.swift
//  watson-bar-icon
//
//  Created by Kai Hildebrandt on 24.11.18.
//  Copyright © 2018 Kai Hildebrandt. All rights reserved.
//

import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    var timer: Timer!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        updateStatusItem(aNotification)
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(updateStatusItem(_:)), userInfo: nil, repeats: true)
    }
    
    @objc func updateStatusItem(_ sender: Any?){
        let imageName: String
        if isStarted() {
            imageName = "timer-4x"
        }else{
            imageName = "media-stop-4x"
        }
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name(imageName))
            button.action = #selector(updateStatusItem(_:))
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        timer.invalidate()
    }
    
    func isStarted() -> Bool {
        let output: String = getStatusOutput()
        return output.range(of:"No project started") == nil
    }
    
    func getStatusOutput() -> String {
        // Create a Task instance
        let task = Process()
        
        // Set the task parameters
        
        //task.launchPath = "/usr/bin/git"
        //task.arguments = ["--version"]
        
        //task.launchPath = "/usr/bin/env"
        //task.arguments = ["/usr/local/bin/watson", "status"]
        // => env: /usr/local/bin/watson: Operation not permitted
        
        task.launchPath = "/usr/local/bin/watson"
        task.arguments = ["status"]
        // => launch path not accessible
        
        // Create a Pipe and make the task
        // put all the output there
        let pipe = Pipe()
        task.standardOutput = pipe
        
        // Launch the task
        task.launch()
        
        // Get the data
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: String.Encoding.utf8)
        print(output!)
        return output!
    }


}

