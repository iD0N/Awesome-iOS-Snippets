//
//  String.swift
//  Awesome-iOS-Snippets
//
//  Created by Don on 11/17/19.
//  Copyright © 2019 Don. All rights reserved.
//

import Foundation


extension String {
	
	func cleanNumber() -> String {
		return self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
	}
	func formatPhone() -> String {
		
		var string = self.replacingOccurrences(of: "+98", with: "0")
		string = string.replacingOccurrences(of: "0098", with: "0")
		
		let cleanNumber = string.cleanNumber()
		let format: String = "XXXX XXX XX XX"
		
		var result = ""
		var index = cleanNumber.startIndex
		for ch in format {
			if index == cleanNumber.endIndex {
				break
			}
			if ch == "X" {
				result.append(cleanNumber[index])
				index = cleanNumber.index(after: index)
			} else {
				result.append(ch)
			}
		}
		return result
	}
	var isValidNumber: Bool {
		if self.starts(with: "09")
		{
			let phoneNumberRegex = "^\\d{11}$"
			let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
			let isValidPhone = phoneTest.evaluate(with: self)
			return isValidPhone
		}
		return false
	}
}


extension String
{
	
	@nonobjc var toEnglishNumbers: String {
		get
		{
			
			let persianNumbers = ["۰","۱","۲","۳","۴","۵","۶","۷","۸","۹"]
			var string = self
			for (index, item) in persianNumbers.enumerated()
			{
				string = string.replacingOccurrences(of: item, with: "\(index)")
			}
			return string
		}
	}
	@nonobjc var toPersianNumbers: String {
		get
		{
			let persianNumbers = ["۰","۱","۲","۳","۴","۵","۶","۷","۸","۹"]
			var string = self
			for (index, item) in persianNumbers.enumerated()
			{
				string = string.replacingOccurrences(of: "\(index)", with: item)
			}
			return string
		}
	}
}


extension String
{
	
	func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
		let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
		let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
		
		return ceil(boundingBox.height)
	}
	
	func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
		let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
		let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
		
		return ceil(boundingBox.width)
	}
}
