//
//  RikkaKichiku.swift
//  RikkaKichiku
//
//  Created by ShinCurry on 2018/9/2.
//  Copyright © 2018年 Moeoverflow. All rights reserved.
//

import ScreenSaver
import AVFoundation
import AVKit
import Alamofire

class RikkaKichiku: ScreenSaverView {
    
    var defaultsManager: DefaultsManager = DefaultsManager()
    lazy var sheetController: ConfigureSheetController = ConfigureSheetController()
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        self.animationTimeInterval = 1.0 / 30.0

        self.wantsLayer = true
        let rikkakichikuLayer = RikkaKichikuLayer(frame: self.frame)
        self.layer = rikkakichikuLayer
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override var hasConfigureSheet: Bool {
        return true
    }

    override var configureSheet: NSWindow? {
        return sheetController.window
    }
}
