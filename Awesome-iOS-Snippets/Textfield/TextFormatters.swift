//
//  TextFormatters.swift
//  Don
//
//  Created by Don on 3/13/20.
//  Copyright © 2020 Don. All rights reserved.
//

import Foundation


class TextFormatters {
	typealias Formatter = (String?) -> String
	typealias Validator = (String?) -> String
	private var formatter: Formatter
	private var validator: Validator?
	init(_ formatter: @escaping Formatter) {
		self.formatter = formatter
	}
	static func custom(_ formatter: @escaping Formatter) -> TextFormatters {
		return TextFormatters(formatter)
	}
	func onValidate(_ validator: @escaping Validator) -> TextFormatters {
		self.validator = validator
		return self
	}
	func format(_ text: String?) -> String {
		return formatter(text)
	}
	func validate(_ text: String?) -> String {
		return validator?(text) ?? text ?? ""
	}
	static let number = TextFormatters { (text) -> String in
		
		var formatted = text?.toEnglishNumbers.cleanNumber()
		formatted = formatted?.formatPrice(emptyState: "0")
		return formatted ?? ""
	}.onValidate { (text) -> String in
		return text?.toEnglishNumbers.cleanNumber() ?? ""
	}
	static let price = TextFormatters { (text) -> String in
		
		var formatted = text?.toEnglishNumbers.cleanNumber()
		formatted = formatted?.formatPrice(emptyState: "0").addCurrency
		return formatted ?? ""
	}.onValidate { (text) -> String in
		return text?.toEnglishNumbers.cleanNumber() ?? ""
	}
	static let rialPrice = TextFormatters { (text) -> String in
		var formatted = text?.toEnglishNumbers.cleanNumber()
		formatted = formatted?.formatPrice(emptyState: "0").addCurrencyToPrice(currency: "ریال")
		return formatted ?? ""
	}.onValidate { (text) -> String in
		return text?.toEnglishNumbers.cleanNumber() ?? ""
	}
	static let phone = TextFormatters { (text) -> String in
		
		var formatted = text?.toEnglishNumbers.cleanNumber()
		formatted = formatted?.replacingOccurrences(of: "+98", with: "0")
		formatted = formatted?.replacingOccurrences(of: "0098", with: "0")
		
		guard let cleanNumber = formatted else { return ""}
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
	}.onValidate { (text) -> String in
		return text?.toEnglishNumbers.cleanNumber() ?? ""
	}
	static let creditCard = TextFormatters { (text) -> String in
		
		var formatted = text?.toEnglishNumbers.cleanNumber()
		
		guard let cleanNumber = formatted else { return ""}
		let format: String = "XXXX XXXX XXXX XXXX"
		
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
	}.onValidate { (text) -> String in
		return text?.toEnglishNumbers.cleanNumber() ?? ""
	}
}
