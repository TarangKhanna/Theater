//
//  RoundView.swift
//  Theater
//
//  Created by Tarang khanna on 1/14/16.
//  Copyright © 2016 Tarang khanna. All rights reserved.
//

import UIKit

@IBDesignable
class RoundView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
}
