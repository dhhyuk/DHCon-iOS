//
//  CALayer+Application.swift
//  DHCon
//
//  Created by 김동혁 on 20/04/2019.
//  Copyright © 2019 김동혁. All rights reserved.
//

import UIKit


extension CALayer {
    
    /**
     * 애니메이션을 없이 값을 바꾸는 함수
     * UIView.performWithoutAnimation과 같은 동작
     */
    class func performWithoutAnimation(_ actionsWithoutAnimation: () -> Void){
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        CATransaction.setDisableActions(true)
        actionsWithoutAnimation()
        CATransaction.commit()
    }
}
