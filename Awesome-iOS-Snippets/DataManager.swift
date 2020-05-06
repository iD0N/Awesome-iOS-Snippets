//
//  DataManager.swift
//  Chamedonam
//
//  Created by Don on 8/23/19.
//  Copyright © 2019 Arvin Alizadeh. All rights reserved.
//

import Foundation

class DataManager {
	
	static var currentVersion = 1
	static var supportNumber = "02188567592"
	static var supportInstagram = "@chamedoonam"
	static var supportTelegram = "@chamedoonam_info"
	
	static var faqURL = "http://chamedoonam.com"
	static var contactusURL = "http://chamedoonam.com"
	static var termsAndConditionsURL = "http://chamedoonam.com"
	static var appRulesURL = "http://chamedoonam.com"
	static var shareURL = "http://chamedoonam.com"
	static var residenceRulesURL = "http://chamedoonam.com"
	static var eventRulesURL = "http://chamedoonam.com"
	static var reportFakeDataURL = "http://chamedoonam.com"
	static var cancelationRulesURL = "http://chamedoonam.com"
	
	var fcmToken = ""
	
	
	static var standard = DataManager()
	var token: String
	{
		get {
			if let token = UserDefaults.standard.value(forKey: "token") as? String {
				ApiManager.token = token
				return token
			}
			return ""
		}
		set {
			ApiManager.token = newValue
			UserDefaults.standard.set(newValue, forKey: "token")
		}
	}
	var refreshToken: String?
	{
		get {
			if let token = UserDefaults.standard.value(forKey: "refreshToken") as? String {
				ApiManager.refreshToken = token
				return token
			}
			return ""
		}
		set {
			ApiManager.refreshToken = newValue ?? ""
			UserDefaults.standard.set(newValue, forKey: "refreshToken")
		}
	}
	func logoutUser() {
		UserDefaults.standard.removeObject(forKey: "token")
		UserDefaults.standard.removeObject(forKey: "refreshToken")
		ApiManager.token = ""
		ApiManager.refreshToken = ""
		
	}
}

extension UserDefaults {
	func decode<T : Codable>(for type : T.Type, using key : String) -> T? {
		let defaults = UserDefaults.standard
		guard let data = defaults.object(forKey: key) as? Data else {return nil}
		let decodedObject = try? PropertyListDecoder().decode(type, from: data)
		return decodedObject
	}
	
	func encode<T : Codable>(for type : T, using key : String) {
		let defaults = UserDefaults.standard
		let encodedData = try? PropertyListEncoder().encode(type)
		defaults.set(encodedData, forKey: key)
		defaults.synchronize()
	}
}
