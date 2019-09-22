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

class RikkaKichiku: ScreenSaverView {
    
    var defaultsManager: DefaultsManager = DefaultsManager()
    lazy var sheetController: ConfigureSheetController = ConfigureSheetController()
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        self.animationTimeInterval = 1.0 / 30.0
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override var hasConfigureSheet: Bool {
        return true
    }

    override var configureSheet: NSWindow? {
        return sheetController.window
    }
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    func setup() {
        // setup a CALayer
        self.layer = CALayer()
        guard let layer = self.layer else {
            fatalError("Couldn't create layer")
        }
        self.wantsLayer = true
        layer.backgroundColor = NSColor.black.cgColor
        layer.needsDisplayOnBoundsChange = true
        layer.frame = self.bounds
        
        // Init a AVPlayer
        let videoUrlStr = defaultsManager.getVideoUrl()
        let videoUrlArr = videoUrlStr!.split{$0 == ","}.map(String.init)
        let videoUrlArrSize = videoUrlArr.count
        var videoUrl = URL(string: "https://animeloop.org/files/mp4_1080p/598f4b40ed178675bf1ee936.mp4")!
        if(videoUrlArrSize > 0)
        {
            let randomNumber = Int.random(in: 0..<videoUrlArrSize)
            videoUrl = URL(string: videoUrlArr[randomNumber])!
        }
        let playerItem = AVPlayerItem(url: videoUrl)
        player = AVPlayer(playerItem: playerItem)
        player.play()

        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main, using: { _ in
            self.player.seek(to: CMTime.zero)
            self.player.play()
        })
        
        // setup a player layer
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        playerLayer.frame = layer.bounds
        layer.addSublayer(playerLayer)
    }
}
