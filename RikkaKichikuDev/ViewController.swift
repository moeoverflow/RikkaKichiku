//
//  ViewController.swift
//  RikkaKichikuDev
//
//  Created by ShinCurry on 2019/10/1.
//  Copyright © 2019 Moeoverflow. All rights reserved.
//

import Cocoa
import AVKit

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.wantsLayer = true
        let rikkakichikuLayer = RikkaKichikuLayer(frame: self.view.frame)
        self.view.layer = rikkakichikuLayer
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

