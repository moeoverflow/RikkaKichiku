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

        AF.request("https://api.animeloop.org/loops/best/rand?n=9", method: .get).responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let jsonData):
                let json = (jsonData as! Dictionary<String, Any>)["loops"] as! [Dictionary<String, Any>]
                let urls = json.map { "https://animeloop.org/files/mp4_1080p/\($0["_id"] as! String).mp4" }
                self.initPlayers(layer: layer, urls: urls)
                break
            case .failure(let error):
                layer.backgroundColor = NSColor.red.cgColor
                break
            }
        })
    }
    
    private func initPlayers(layer: CALayer, urls: [String]) {
        let colWidth = layer.frame.width / 3
        let rowHeight = layer.frame.height / 3
        
        for (index, url) in urls.enumerated() {
            let col = index % 3
            let row = index / 3
            
            let player = AVPlayer(playerItem: AVPlayerItem(url: URL(string: url)!))
            playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = .resizeAspectFill
            playerLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]

            let frame = NSRect(x: CGFloat(col) * colWidth, y: CGFloat(row) * rowHeight, width: colWidth, height: rowHeight)
            playerLayer.frame = frame
            layer.addSublayer(playerLayer)
            
            player.play()

            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main, using: { _ in
                player.seek(to: CMTime.zero)
                player.play()
            })
        }
    }
}
