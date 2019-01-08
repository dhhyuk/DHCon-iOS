//
//  CloseView.swift
//  DHCon
//
//  Created by 김동혁 on 03/01/2019.
//  Copyright © 2019 김동혁. All rights reserved.
//

import UIKit

class CloseView: UIView {
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.beginPath()
        
        context.move(to: CGPoint(x: 1.5, y: 1.5))
        context.addLine(to: CGPoint(x: rect.width - 1.5, y: rect.height - 1.5))
        context.move(to: CGPoint(x: 1.5, y: rect.height - 1.5))
        context.addLine(to: CGPoint(x: rect.width - 1.5, y: 1.5))
        context.setLineWidth(3)
        context.setStrokeColor(#colorLiteral(red: 0.2509803922, green: 0.2509803922, blue: 0.3529411765, alpha: 1).cgColor)
        
        
        context.closePath()
        context.strokePath()
        
        context.setFillColor(#colorLiteral(red: 0.2509803922, green: 0.2509803922, blue: 0.3529411765, alpha: 1).cgColor)
        context.beginPath()
        context.addArc(center: CGPoint(x: 1.5, y: 1.5), radius: 1.5, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        context.closePath()
        context.fillPath()
        
        context.beginPath()
        context.addArc(center: CGPoint(x: rect.width - 1.5, y: rect.height - 1.5), radius: 1.5, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        context.closePath()
        context.fillPath()
        
        context.beginPath()
        context.addArc(center: CGPoint(x: 1.5, y: rect.height - 1.5), radius: 1.5, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        context.closePath()
        context.fillPath()
        
        context.beginPath()
        context.addArc(center: CGPoint(x: rect.width - 1.5, y: 1.5), radius: 1.5, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        context.closePath()
        context.fillPath()
        
    }
}
