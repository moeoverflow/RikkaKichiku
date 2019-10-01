//
//  GridLayer.swift
//  RikkaKichiku
//
//  Created by ShinCurry on 2019/10/1.
//  Copyright © 2019 Moeoverflow. All rights reserved.
//

import Cocoa

class GridLayer: CALayer {
    
    override init() {
        super.init()
        self.backgroundColor = NSColor.black.cgColor
        self.needsDisplayOnBoundsChange = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var colWidth: CGFloat = 0.00
    var rowHeight: CGFloat = 0.00

    var cellLayers: [String: CALayer] = [:]
    var itemLayers: [String: CALayer] = [:]

    func initGrid(cols: Int, rows: Int, renderItem: (Int, Int) -> CALayer) {
        self.colWidth = self.frame.width / CGFloat(cols)
        self.rowHeight = self.frame.height / CGFloat(rows)
        
        for col in 0..<cols {
            for row in 0..<rows {
                let frame = NSRect(
                    x: CGFloat(col) * self.colWidth,
                    y: CGFloat(row) * self.rowHeight,
                    width: self.colWidth,
                    height: self.rowHeight
                )

                let cellLayer = CALayer()
                cellLayer.frame = frame
                cellLayer.masksToBounds = true

                let itemLayer = renderItem(col, row)
                itemLayer.frame = cellLayer.bounds
                cellLayer.addSublayer(itemLayer)

                self.itemLayers["\(col):\(row)"] = itemLayer
                self.cellLayers["\(col):\(row)"] = cellLayer

                self.addSublayer(cellLayer)
            }
        }
    }
    
    func replaceItem(col: Int, row: Int, newLayer: LoopItemLayer) {
        guard let cellLayer = self.cellLayers["\(col):\(row)"] else { return }
        guard let itemLayer = self.itemLayers["\(col):\(row)"] else { return }
        
        newLayer.frame = itemLayer.frame
        newLayer.opacity = 0
        cellLayer.addSublayer(newLayer)

        // TODO: change implement, do animation after AVPlayer ready callback
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { _ in

            CATransaction.begin()
            CATransaction.setDisableActions(true)
            newLayer.opacity = 1

            let animationOut = self.getAnimation(
                from: itemLayer.position,
                to: CGPoint(x: itemLayer.position.x - self.colWidth, y: itemLayer.position.y)
            )
            let animationIn = self.getAnimation(
                from: CGPoint(x: itemLayer.position.x + self.colWidth, y: itemLayer.position.y),
                to: itemLayer.position
            )

            CATransaction.setCompletionBlock {
                itemLayer.removeFromSuperlayer()
                self.itemLayers["\(col):\(row)"] = newLayer
            }

            itemLayer.add(animationOut, forKey: "position")
            newLayer.add(animationIn, forKey: "position")
            

            CATransaction.commit()
        })
    }
    
    private func getAnimation(from: CGPoint, to: CGPoint) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = from
        animation.toValue = to
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.autoreverses = false
        return animation
    }
}
