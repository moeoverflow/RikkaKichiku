//
//  TimerItemLayer.swift
//  RikkaKichiku
//
//  Created by ShinCurry on 2019/10/1.
//  Copyright © 2019 Moeoverflow. All rights reserved.
//

import Cocoa

class TimerItemLayer: CALayer {
    override init() {
        super.init()

        let label = CATextLayer()
        label.foregroundColor = NSColor.white.cgColor
        label.isWrapped = true
        label.alignmentMode = .center
        label.contentsScale = (NSScreen.main?.backingScaleFactor)!
        self.addSublayer(label)
        self.label = label
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            let dateString = dateFormatter.string(from: date)
            label.fontSize = self.frame.size.height / 3
            label.frame = CGRect(x: 0, y: self.frame.size.height / 2 - label.fontSize / 2, width: self.frame.size.width, height: label.fontSize)
            self.label.string = dateString
        })
    }
    
    var label: CATextLayer!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
