//
//  UIBezier.swift
//  UIKit-Animations
//
//  Created by Кизим Илья on 28.02.2024.
//

import UIKit

extension UIBezierPath  {
    
    func getHearts(originalRect: CGRect, scale: Double) -> UIBezierPath {
        
        let scaledWidth = (originalRect.size.width * CGFloat(scale))
        let scaledXValue = ((originalRect.size.width) - scaledWidth) / 2
        let scaledHeight = (originalRect.size.height * CGFloat(scale))
        let scaledYValue = ((originalRect.size.height) - scaledHeight) / 2
        
        let scaledRect = CGRect(x: scaledXValue, y: scaledYValue, width: scaledWidth, height: scaledHeight)
        self.move(to: CGPointMake(originalRect.size.width/2, scaledRect.origin.y + scaledRect.size.height))
        
        self.addCurve(to: CGPointMake(scaledRect.origin.x, scaledRect.origin.y + (scaledRect.size.height/4)),
                             controlPoint1:CGPointMake(scaledRect.origin.x + (scaledRect.size.width/2), scaledRect.origin.y + (scaledRect.size.height*3/4)) ,
                             controlPoint2: CGPointMake(scaledRect.origin.x, scaledRect.origin.y + (scaledRect.size.height/2)) )
        
        self.addArc(withCenter: CGPointMake( scaledRect.origin.x + (scaledRect.size.width/4),scaledRect.origin.y + (scaledRect.size.height/4)),
                              radius: (scaledRect.size.width/4),
                    startAngle: .pi,
                              endAngle: 0,
                              clockwise: true)
        
        self.addArc(withCenter: CGPointMake( scaledRect.origin.x + (scaledRect.size.width * 3/4),scaledRect.origin.y + (scaledRect.size.height/4)),
                              radius: (scaledRect.size.width/4),
                              startAngle: .pi,
                              endAngle: 0,
                              clockwise: true)
        
        self.addCurve(to: CGPointMake(originalRect.size.width/2, scaledRect.origin.y + scaledRect.size.height),
                             controlPoint1: CGPointMake(scaledRect.origin.x + scaledRect.size.width, scaledRect.origin.y + (scaledRect.size.height/2)),
                             controlPoint2: CGPointMake(scaledRect.origin.x + (scaledRect.size.width/2), scaledRect.origin.y + (scaledRect.size.height*3/4)) )
        self.close()
        return self
    }
}
