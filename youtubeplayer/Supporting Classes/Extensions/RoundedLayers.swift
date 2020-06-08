//
//  imagelayers.swift
//  aasoa
//
//  Created by KHUSHBOO on 07/03/19.
//  Copyright © 2019 KHUSHBOO. All rights reserved.
//

import Foundation
import UIKit

//MARK:- UIVIEW

@IBDesignable
class roundedlabel: UILabel {
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
}

// MARK:- Image View
@IBDesignable
class roundedimage: UIImageView {
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            
            layer.masksToBounds = true
            self.layoutIfNeeded()
        }
    }
}


//MARK:- Button
@IBDesignable
class roundedbutton: UIButton {
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            
            layer.masksToBounds = true
        }
    }
}


//MARK:- uiview
@IBDesignable
class rounded_view: UIView {
    // Border Color
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    //Border Width
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    //Corner Radius
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            
            layer.masksToBounds = true
        }
    }
    
   
}

//MARK:- Text Feild
@IBDesignable
class roundedtf: UITextField {
    // Border Color
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    //Border Width
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    //Corner Radius
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            
            layer.masksToBounds = true
        }
    }
    
    // Left Padding
    @IBInspectable var leftpadding: CGFloat = 0 {
        didSet{
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: leftpadding, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
    }
    
    // Right Padding
    
    @IBInspectable var rightpadding: CGFloat = 0 {
        didSet{
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: rightpadding, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
}
