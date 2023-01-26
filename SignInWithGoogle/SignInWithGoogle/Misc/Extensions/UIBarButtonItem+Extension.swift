//
//  UIBarButtonItem+Extension.swift
//  SignInWithGoogle
//
//  Created by Luiz Araujo on 26/01/23.
//

import UIKit

extension UIBarButtonItem {

    static func signOut(target: AnyObject, action: Selector) -> UIBarButtonItem {
        
        return button(title: "Sign Out", target: target, action: action)
    }

    private static func button(title: String, target: AnyObject, action: Selector) -> UIBarButtonItem {
        
        return UIBarButtonItem(title: title, style: .done, target: target, action: action)
    }

}
