//
//  String+Extension.swift
//  SignInWithGoogle
//
//  Created by Luiz Araujo on 21/01/23.
//

import Foundation

extension String {
    
    /// This function will be used to validate the text making sure it fulfills the requirement for the email.
    func isValidEmail() -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", regex)
        
        return emailTest.evaluate(with: self)
    }
    
    /// This is a rather strong password which requires small letter, capital letter, special case and number.
    func isValidPassword() -> Bool {
        let regex = "(?=^.{8,}$)(?=.*\\d)(?=.*[!@#$%^&*]+)(?![.\\n])(?=.*[A-Z])(?=.*[a-z]).*$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", regex)
        return passwordTest.evaluate(with: self)
    }
    
    /// This regex requires only 8 character and the number could be between 0 to 9. You may adjust the limit according to your need.
    func isValidPhone() -> Bool {
        let regex = "^[0-9]{8}$"
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", regex)
        return phoneTest.evaluate(with: self)
    }
}
