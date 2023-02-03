//
//  Utilities.swift
//  CustomLoginDemo
//
//  Created by Luiz Araujo on 29/01/23.
//

import UIKit

class Utilities {
    static func styleTextField(_ textField: UITextField) {
        /// Create the bottom lline
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0,
                                  y: textField.frame.height - 2,
                                  width: textField.frame.width,
                                  height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        
        /// Remove border on text field
        textField.borderStyle = .none
        
        /// Add the line to the text field
        textField.layer.addSublayer(bottomLine)
    }
    
    static func styleFilledButton(_ button: UIButton) {
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button: UIButton) {
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    /// Source: https://iosdevcenters.blogspot.com/2017/06/password-validation-in-swift-30.html
    static func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
}
