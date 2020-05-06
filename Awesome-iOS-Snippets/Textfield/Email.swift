//
//  Email.swift
//  Awesome-iOS-Snippets
//
//  Created by Don on 4/6/20.
//  Copyright © 2020 Don. All rights reserved.
//

import Foundation


@propertyWrapper
struct Email<Value: StringProtocol> {
    var value: Value?

    var wrappedValue: Value? {
        get {
            return validate(email: value) ? value : nil
        }
        set {
            value = newValue
        }
    }
	
	init(wrappedValue value: Value?) {
		self.value = value
	}
    
    private func validate(email: Value?) -> Bool {
        guard let email = email else { return false }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
