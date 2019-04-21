//
//  ConLabelView.swift
//  DHCon
//
//  Created by 김동혁 on 20/04/2019.
//  Copyright © 2019 김동혁. All rights reserved.
//

import UIKit

class ConLabelView: UIView {
    
    lazy var layerLabel: CATextLayer = {
        let layer = CATextLayer()
        layer.alignmentMode = CATextLayerAlignmentMode.center
        layer.font = "AppleSDGothicNeo-SemiBold" as CFTypeRef
        layer.fontSize = 12
        layer.foregroundColor = UIColor.black.cgColor
        
        layer.contentsScale = UIScreen.main.scale
        layer.frame = CGRect(x: 0, y: self.bounds.height - 12 - layer.fontSize, width: self.bounds.width, height: layer.fontSize)
        
        layer.string = ""
        
        return layer
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        self.layer.addSublayer(self.layerLabel)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        self.layerLabel.frame = CGRect(x: 0, y: self.bounds.height - 12 - layerLabel.fontSize, width: self.bounds.width, height: layerLabel.fontSize)
    }
}
