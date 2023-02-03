//
//  UIView+RoundedCorner.swift
//  SignInWithGoogle
//
//  Created by Luiz Araujo on 03/02/23.
//

import UIKit.UIView
import UIKit.UIColor
import UIKit.NSShadow

extension UIView {
    
    func addRoundedCornerToView(targetView : UIView?)
    {
        //UIView Corner Radius
        targetView!.layer.cornerRadius  = 5.0;
        targetView!.layer.masksToBounds = true
        
//        //UIView Set up boarder
//        targetView!.layer.borderColor = UIColor.yellow.cgColor;
//        targetView!.layer.borderWidth = 3.0;
        
        //UIView Drop shadow
        targetView!.layer.shadowColor   = UIColor.darkGray.cgColor;
        targetView!.layer.shadowOffset  = CGSizeMake(2.0, 2.0)
        targetView!.layer.shadowOpacity = 1.0
    }
}
