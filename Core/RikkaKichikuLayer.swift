//
//  RikkaKichikuLayer.swift
//  RikkaKichiku
//
//  Created by ShinCurry on 2019/10/1.
//  Copyright © 2019 Moeoverflow. All rights reserved.
//

import Cocoa

class RikkaKichikuLayer: CALayer {
    
    override init() {
        super.init()
    }
    
    convenience init(frame: CGRect) {
        self.init()
        self.gridLayer = GridLayer()
        self.frame = frame
        self.gridLayer.frame = frame
        self.addSublayer(self.gridLayer)
        setup()
    }
    
    func setFrame(frame: CGRect) {
        self.frame = frame
        self.gridLayer.frame = frame
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    let gridCols = 3
    let gridRows = 3
    
    var gridLayer: GridLayer!
    
    var isFetchingData = false
    var loops: [String] = []
    
    func setup() {
        AnimeloopAPI.getRandomFavLoops(n: 18) { data in
            guard let loops = data else { return }

            guard loops.count >= 9 else { return }
            let initLoops = Array(loops[0..<9])
            self.initPlayers(urls: initLoops)

            guard loops.count >= 9 else { return }
            self.loops = Array(loops[8..<18])

            self.initTimer()
        }
        
    }
    
    private func initPlayers(urls: [String]) {

        self.gridLayer.initGrid(cols: self.gridCols, rows: self.gridRows, renderItem: { (col, row) in
            let url = urls[col * self.gridCols + row]
            let playerLayer = LoopItemLayer(url: url)
            return playerLayer
        })
        
    }

    private func initTimer() {
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { timer in
            let col = Int.random(in: 0..<self.gridCols)
            let row = Int.random(in: 0..<self.gridRows)
            
            guard self.loops.count > 5 else {
                guard !self.isFetchingData else { return }
                self.isFetchingData = true
                AnimeloopAPI.getRandomFavLoops(n: 9) { data in
                    guard let loops = data else { return }
                    guard loops.count >= 9 else { return }
                
                    self.loops += loops
                    self.isFetchingData = false
                }
                return
            }
            guard self.loops.count >= 1 else { return }

            let loop = self.loops.removeFirst()
            let playerLayer = LoopItemLayer(url: loop)
            self.gridLayer.replaceItem(col: col, row: row, newLayer: playerLayer)
        })
    }
}
