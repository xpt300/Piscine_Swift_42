//
//  Form.swift
//  D06
//
//  Created by Maxime JOUBERT on 1/28/20.
//  Copyright © 2020 Maxime JOUBERT. All rights reserved.
//

import UIKit


class Form: UIView {
    
    var size : CGFloat = 100
    var isCircle = false
    var originalBounds: CGRect!
    
    init(point: CGPoint, maxWidth: CGFloat, maxHeigth: CGFloat) {
        var x = point.x - (self.size / 2)
        var y = point.y - (self.size / 2)
        
        if (x < 0) {
            x = 0
        }
        if (x > maxWidth - self.size) {
            x = maxWidth - self.size
        }
        if (y < 0) {
            y = 0
        }
        if (y > maxHeigth - self.size) {
            y = maxHeigth - self.size
        }
        let random = Int(arc4random_uniform(2))
        switch random {
        case 0 :
            super.init(frame: CGRect(x: x, y: y, width: self.size, height: self.size))
            self.originalBounds = self.bounds;
        default:
            super.init(frame: CGRect(x: x, y: y, width: self.size, height: self.size))
            self.originalBounds = self.bounds;
            self.layer.cornerRadius = size/2
            self.isCircle = true
        }
        self.backgroundColor = getRandomColor()
    }
    
    func getRandomColor() -> UIColor {
        let randomRed:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomGreen:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomBlue:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
