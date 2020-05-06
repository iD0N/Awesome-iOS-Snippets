//
//  Date.swift
//  Awesome-iOS-Snippets
//
//  Created by Don on 11/17/19.
//  Copyright © 2019 Don. All rights reserved.
//

import Foundation


extension String
{
	func toDate(format: String = "yyyy/MM/dd", locale: Locale = Locale(identifier: "fa_IR"), timezone: Timezone = TimeZone(secondsFromGMT: 210*60)) -> Date
	{
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = format
		dateFormatter.timeZone = timezone
		dateFormatter.locale = locale
		return dateFormatter.date(from:self)!
	}
}
extension Date {
	
	func stringToDate(dateString: String, format: String = "yyyy/MM/dd") -> Date {
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = format
		dateFormatter.locale = Locale(identifier: "fa_IR")
		let date = dateFormatter.date(from:dateString)!
		return date
	}
	func unixToDate(unixTimestamp: Int) -> Date {
		
		return Date(timeIntervalSince1970: Double(unixTimestamp))
	}
	func unixToDate(timestamps: [Int]) -> [Date] {
		
		var dateArray: [Date] = []
		for item in timestamps
		{
			dateArray.append(Date(timeIntervalSince1970: Double(unixTimestamp)))
		}
		return dateArray
	}
	func stringToDate(dateStrings: [String], format: String = "yyyy/MM/dd") -> [Date] {
		var dateArray: [Date] = []
		for item in dateStrings
		{
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = format
			dateFormatter.locale = Locale(identifier: "fa_IR")
			let date = dateFormatter.date(from:item)!
			dateArray.append(date)
		}
		return dateArray
	}
	func component(component: Calendar.Component, identifier: Calendar.Identifier = .persian) -> Int {
		
		let calendar = Calendar(identifier: identifier)
		return calendar.component(component, from: self)
	}
	func getDaysInMonth(identifier: Calendar.Identifier = .persian) -> Int{
		let calendar = Calendar(identifier: identifier)
		
		let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
		let date = calendar.date(from: dateComponents)!
		
		let range = calendar.range(of: .day, in: .month, for: date)!
		let numDays = range.count
		
		return numDays
	}
	func getFirstDayWeekday(identifier: Calendar.Identifier = .persian) -> Int {
		
		let calendar = Calendar(identifier: identifier)
		
		let isoDate = String(format: "%04d-%02d-01",calendar.component(.year, from: self), calendar.component(.month, from: self))
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		dateFormatter.locale = Locale(identifier: "fa_IR")
		let date = dateFormatter.date(from:isoDate)!
		return calendar.component(.weekday, from: date) % 7
	}
	func getWeekday(identifier: Calendar.Identifier = .persian) -> Int {
		
		let calendar = Calendar(identifier: identifier)
		
		return (calendar.component(.weekday, from: self)) % 7
	}
	func getPersianWeekDay(day: Int, long: Bool = false) -> String {
		
		let weekdays = ["ش",
						"ی",
						"د",
						"س",
						"چ",
						"پ",
						"ج"
		]
		let weekdaysLong = ["شنبه",
							"یکشنبه",
							"دوشنبه",
							"سه‌شنبه",
							"چهارشنبه",
							"پنج‌شنبه",
							"جمعه"]

		return long ? weekdaysLong[day] : weekdays[day]
	
	}
	func getPersianMonthName(month: Int = -1) -> String
	{
		let monthNames =
		["فروردین",
		 "اردیبهشت",
		 "خرداد",
		 "تیر",
		 "مرداد",
		 "شهریور",
		 "مهر",
		 "آبان",
		 "آذر",
		 "دی",
		 "بهمن",
		 "اسفند"
		]
		if month == -1
		{
			let calendar = Calendar(identifier: .persian)
			return monthNames[calendar.component(.month, from: self)-1]
		}
		else
		{
			return monthNames[month - 1]
		}
	}
}
