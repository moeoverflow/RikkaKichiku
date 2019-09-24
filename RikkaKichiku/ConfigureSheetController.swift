//
//  ConfigureSheetController.swift
//  RikkaKichiku
//
//  Created by edisonlee55 on 2019/9/22.
//  Copyright © 2018年 Moeoverflow. All rights reserved.
//

import Cocoa

class ConfigureSheetController : NSObject {
    var defaultsManager = DefaultsManager()

    @IBOutlet var window: NSWindow?
    @IBOutlet var videoUrl: NSTextField!

    override init() {
        super.init()
        let myBundle = Bundle(for: ConfigureSheetController.self)
        myBundle.loadNibNamed("ConfigureSheet", owner: self, topLevelObjects: nil)
        videoUrl.stringValue = String(defaultsManager.videoUrl)
    }

    @IBAction func videoUrlFinished(_ sender: Any) {
        defaultsManager.videoUrl = String(videoUrl.stringValue)
    }
    
    @IBAction func closeConfigureSheet(_ sender: AnyObject) {
        window?.sheetParent!.endSheet(window!, returnCode: (sender.tag == 1) ? NSApplication.ModalResponse.OK : NSApplication.ModalResponse.cancel)
    }
}

