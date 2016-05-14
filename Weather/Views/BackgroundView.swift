//
//  BackgroundView.swift
//  Weather Outside
//
//  Created by Sofia  Cepeda
//  
//

import UIKit

class BackgroundView: UIView {
    
    
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
        
    }
    
}
