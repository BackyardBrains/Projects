//
//  TextFieldExtension.swift
//  TMR App
//
//  Created by Robert Zhang on 7/6/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation
import UIKit

extension UITextField{
    convenience init(text:String,placeholder:String,font:String,fontSize:CGFloat,textColor:UIColor,textAlignment:NSTextAlignment,border:UITextBorderStyle,adjustToFit:Bool,rect:CGRect) {
        self.init(frame:rect)
        self.text = text
        self.placeholder = placeholder
        self.font = UIFont(name: font, size: fontSize)
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.borderStyle = border
        self.adjustsFontSizeToFitWidth = adjustToFit
    }
    
    
}
