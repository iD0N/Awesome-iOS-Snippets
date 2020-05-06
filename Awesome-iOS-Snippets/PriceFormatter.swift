//
//  PriceFormatter.swift
//  Awesome-iOS-Snippets
//
//  Created by Don on 11/17/19.
//  Copyright © 2019 Don. All rights reserved.
//

import Foundation



extension String {
	
	var addCurrency: String {
		return addCurrencyToPrice(currency: "تومان")
	}
	func addCurrencyToPrice(currency: String) -> String {
		let numString = String(self.filter { "0123456789.".contains($0) })
		guard Double(numString) != nil
			else {
				return self
		}
		return self + " " + currency
	}
	func formatPrice(emptyState: String?) -> String {
		
		let numString = String(self.filter { "0123456789.".contains($0) })
		
		guard let number = Double(numString), number != 0.0 else
		{
			return emptyState ?? ""
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
}


extension Formatter {
	static let withSeparator: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.groupingSeparator = "،"
		formatter.numberStyle = .decimal
		return formatter
	}()
}

extension BinaryInteger {
	var formattedPrice: String {
		return formattedWithEmptyState(emptyState: "رایگان")
	}
	var formattedBalance: String {
		return formattedWithEmptyState(emptyState: "خالی")
	}
	func formattedWithEmptyState(emptyState: String?) -> String {
		
		guard self != 0 else
		{
			return emptyState ?? ""
		}
		return Formatter.withSeparator.string(for: self) ?? ""
	}
}
