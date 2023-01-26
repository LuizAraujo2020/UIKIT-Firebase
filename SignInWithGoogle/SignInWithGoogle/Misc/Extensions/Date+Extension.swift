//
//  Date+Extension.swift
//  SignInWithGoogle
//
//  Created by Luiz Araujo on 25/01/23.
//

import Foundation

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
