//
//  PriceFormatExtensions.swift
//  VillaMilla
//
//  Created by Don on 3/13/20.
//  Copyright © 2020 Don. All rights reserved.
//

import Foundation

extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
	///Returns short price from the given string e.g: 10 میلیون
	func shortPrice() -> String{
		var mainPrice = self
		var floatPrice = ""
		var suffix = ""
		switch mainPrice.count{
		case 0...3:
			floatPrice = "0"
		case 4...6:
			suffix = "هزار"
			floatPrice = mainPrice[mainPrice.count - 3]
			let endIndex = mainPrice.index(mainPrice.endIndex, offsetBy: -3)
			mainPrice = mainPrice.substring(to: endIndex)
		case 7...9:
			suffix = "میلیون"
			floatPrice = mainPrice[mainPrice.count - 6]
			let endIndex = mainPrice.index(mainPrice.endIndex, offsetBy: -6)
			mainPrice = mainPrice.substring(to: endIndex)
		case 10...12:
			suffix = "میلیارد"
			floatPrice = mainPrice[mainPrice.count - 9]
			let endIndex = mainPrice.index(mainPrice.endIndex, offsetBy: -9)
			mainPrice = mainPrice.substring(to: endIndex)
		default:
			break
		}
		if floatPrice == "0"{
			return mainPrice + " " + suffix
		}
		return mainPrice + "/" + floatPrice + " " + suffix
	}

}

extension String {
	
	/// appends "تومان" to a string
	var addCurrency: String {
		return addCurrencyToPrice(currency: "تومان")
	}
	/// appends a custom currency to a string
	func addCurrencyToPrice(currency: String) -> String {
		let numString = String(self.filter { "0123456789.".contains($0) })
		guard Double(numString) != nil
			else {
				return self
		}
		return self + " " + currency
	}
	/// Removes non numerical characters
	func cleanNumber() -> String {
		return self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
	}
	/// returns a formatted price from the given string
	/// - parameter emptyState: string to put instead of zero
	func formatPrice(emptyState: String = "رایگان") -> String {
		
		let numString = String(self.filter { "0123456789.".contains($0) })
		guard let number = Double(numString)
			else {
				return ""
		}
		if Int(numString) == 0
		{
			return emptyState
		}
		
		let formatter = NumberFormatter()
		formatter.currencySymbol = " "
		formatter.minimumFractionDigits = 0
		formatter.locale = Locale.current
		formatter.numberStyle = .currency
		
		if let formattedTipAmount = formatter.string(from: number as NSNumber) {
			return formattedTipAmount
		}
		return self
	}
	/// returns true if the given string is a valid phone number
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
extension Formatter {
	/// Format every 1000 with a , seprator
	static let withSeparator: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.groupingSeparator = "،"
		formatter.numberStyle = .decimal
		return formatter
	}()
}

extension BinaryInteger {
	
	/// Format every 1000 with a , seprator
	var formattedWithSeparator: String {
		guard self != 0
			else
		{
			return "رایگان"
		}
		return Formatter.withSeparator.string(for: self) ?? ""
	}
	/// Format every 1000 with a , seprator, empty state as "رایگان"
	var formattedPrice: String {
		return formattedWithEmptyState(emptyState: "رایگان")
	}
	/// Format every 1000 with a , seprator, empty state as "خالی"
	var formattedBalance: String {
		return formattedWithEmptyState(emptyState: "خالی")
	}
	/// Format every 1000 with a , seprator
	/// - parameter emptyState: string to put instead of zero
	func formattedWithEmptyState(emptyState: String) -> String {
		
		guard self != 0
			else
		{
			return emptyState
		}
		return Formatter.withSeparator.string(for: self) ?? ""
	}
}

extension String
{

	///Translates persian 0-9 numbers to english 0-9 numbers
	@nonobjc var toEnglishNumbers: String {
		get
		{
			
			var string = self
			for (index, item) in ["۰",
			"۱",
			"۲",
			"۳",
			"۴",
			"۵",
			"۶",
			"۷",
			"۸",
				"۹"].enumerated()
			{
				string = string.replacingOccurrences(of: item, with: "\(index)")
			}
			return string
		}
	}
}
