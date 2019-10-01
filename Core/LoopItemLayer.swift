//
//  LoopItemLayer.swift
//  RikkaKichiku
//
//  Created by ShinCurry on 2019/10/1.
//  Copyright © 2019 Moeoverflow. All rights reserved.
//

import Cocoa
import AVKit

class LoopItemLayer: CALayer {
    override init() {
        super.init()
    }
    
    convenience init(url: String) {
        self.init()
        let player = AVPlayer(playerItem: AVPlayerItem(url: URL(string: url)!))
        let playerLayer = AVPlayerLayer(player: player)
        self.player = player
        self.playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.bounds
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]

        player.play()

        self.observer = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main, using: { _ in
            player.seek(to: CMTime.zero)
            player.play()
        })
        
        self.addSublayer(playerLayer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        if self.observer != nil {
            NotificationCenter.default.removeObserver(self.observer!)
        }
    }
    
    var observer: Any?
    
    var playerLayer: AVPlayerLayer!
    var player: AVPlayer!
    var onReady: (() -> Void)?
    
}
