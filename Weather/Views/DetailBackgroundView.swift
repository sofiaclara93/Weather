//
//  DetailBackgroundView.swift
//  Weather Outside
//
//  Created by Sofia  Cepeda
//
//" https://github.com/WERUreo?tab=repositories" for Sun drawing and Path 
//

import UIKit

class DetailBackgroundView: UIView {

    
    override func drawRect(rect: CGRect) {
        
        // Background View
        
        // Color Declarations
        let lightPink: UIColor = UIColor(red: 0.898, green: 0.584, blue: 0.752, alpha: 1.000)
        let darkPink: UIColor = UIColor(red: 0.898, green: 0.337, blue: 0.517, alpha: 1.000)
        
        let context = UIGraphicsGetCurrentContext()
        
        // Gradient Declarations
        let pinkGradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [lightPink.CGColor, darkPink.CGColor], [0, 1])
        
        // Background Drawing
        let backgroundPath = UIBezierPath(rect: CGRectMake(0, 0, self.frame.width, self.frame.height))
        CGContextSaveGState(context)
        backgroundPath.addClip()
        CGContextDrawLinearGradient(context, pinkGradient,
                                    CGPointMake(160, 0),
                                    CGPointMake(160, 568),
                                    [.DrawsBeforeStartLocation, .DrawsAfterEndLocation])
        
        // Sun Path
        
        let circleOrigin = CGPointMake(0, 0.80 * self.frame.height)
        let circleSize = CGSizeMake(self.frame.width, 0.65 * self.frame.height)
        
        let pathStrokeColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 0.390)
        let pathFillColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 0.100)
        
        
        // Sun Drawing
        let sunPath = UIBezierPath(ovalInRect: CGRectMake(circleOrigin.x, circleOrigin.y, circleSize.width, circleSize.height))
        pathFillColor.setFill()
        sunPath.fill()
        pathStrokeColor.setStroke()
        sunPath.lineWidth = 1
        CGContextSaveGState(context)
        CGContextSetLineDash(context, 0, [2, 2], 2)
        sunPath.stroke()
        CGContextRestoreGState(context)
    }

}
