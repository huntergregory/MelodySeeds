//
//  RecordingView.swift
//  MelodySeedsPrototype2
//
//  Created by Hunter Gregory on 9/8/18.
//  Copyright © 2018 Hunter Gregory. All rights reserved.
//

import UIKit

class RecordingView: UIView {

    /*
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        //background color
        context.setFillColor(UIColor.clear.cgColor)
        context.fill(self.bounds)
        
        // Calculate the transform
        let p1 = CGPoint(x: 100, y: 100)
        let p2 = CGPoint(x: 400, y: 400)
        let dx = p2.x - p1.x
        let dy = p2.y - p1.y
        let d = sqrt(dx * dx + dy * dy)
        let a = atan2(dy, dx)
        let cosa = cos(a) // Calculate only once...
        let sina = sin(a) // Ditto
        
        // Initialise our path
        let path = CGMutablePath()
        path.move(to: p1)
        
        // Plot a parametric function with 100 points
        let nPoints = 100
        for t in 0 ... nPoints {
            // Calculate the un-transformed x,y
            let tx = CGFloat(t) / CGFloat(nPoints) // 0 ... 1
            let ty = 0.1 * sin(tx * 2 * CGFloat.pi ) // 0 ... 2π, arbitrary amplitude
            // Apply the transform
            let x = p1.x + d * (tx * cosa - ty * sina)
            let y = p1.y + d * (tx * sina + ty * cosa)
            // Add the transformed point to the path
            path.addLine(to: CGPoint(x: x, y: y))
        }
    }
 */
}
