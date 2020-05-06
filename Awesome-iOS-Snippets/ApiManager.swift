//
//  ApiManager.swift
//  Awesome-iOS-Snippets
//
//  Created by Don on 11/17/19.
//  Copyright © 2019 Don. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class ApiBaseModel<T: Codable>: Codable {
	
	let data: T?
	let statusCode: Int?
	let message: String?
	
	init(data: T?, statusCode: Int?, message: String?) {
		self.data = data
		self.statusCode = statusCode
		self.message = message
	}
}

class APIErrorModel: Codable {
	let code: Int?
	let message: String?
	
	init(code: Int?, message: String?) {
		self.code = code
		self.message = message
	}
    enum CodingKeys: String, CodingKey {
        case code = "statusCode"
        case message = "message"
    }
}

class ApiManager {
	
	enum NetworkError: Error
	{
		case badURL
		case unAuthorized
		case tokenExpired
		case custom(String)
		case timeout
	}
	
	@nonobjc static var url = "http://130.185.76.102/"
	@nonobjc static var domain = "http://130.185.76.102/"
	@nonobjc static var imageURL = url + "images/"
	
	@nonobjc static var apiVersion = 2
	@nonobjc static var timeoutTime = 20
	
	@nonobjc static var refreshToken = ""
	@nonobjc static var token = ""
	
	@nonobjc static let shared: SessionManager = {
		
		let conf = URLSessionConfiguration.default
		conf.timeoutIntervalForResource = timeoutTime // seconds
		conf.timeoutIntervalForRequest = timeoutTime
		return SessionManager(configuration: conf)
	}()
	internal class func AuthorizedUpload(address: String, apiVersion: Int = ApiManager.apiVersion, data: Data, callback: @escaping (Swift.Result<String,NetworkError>)->())
	{
		let url = self.url + address
		
		let auth = "Bearer \(token)".replacingOccurrences(of: "\"", with: "")
		let headers =
				["content-type": "application/json",
				"cache-control": "no-cache",
				"Api-Version": "\(apiVersion)",
				"Authorization": auth]
		
		shared.upload(multipartFormData:
			{ (MultipartFormData) in
			
			MultipartFormData.append(data, withName: "residence", fileName: "residence.jpg", mimeType: "image/jpeg/mp4/jpg/png")
			}, usingThreshold: .max, to: url, method: .post, headers: headers, queue: nil) { (result) in
			
			switch result
			{
			case .success(let upload, _, _):
				
				upload.responseData { (data) in
					
					switch data.response?.statusCode
					{
					case 200:
						callback(.success("Success"))
						
					case 403, 401:
						refreshToken() { (success) in
							if success
							{
								AuthorizedUpload(address: address, imageData: imageData, callback: callback)
							}
							else
							{
								callback(.failure(.tokenExpired))
							}
						}
					case 400:
						guard let stuff = data.data
							else {
								callback(.failure(.badURL))
								return
						}
						let callbackData = try! newJSONDecoder().decode(APIErrorModel.self, from: stuff)
						callback(.failure(.custom(callbackData.message ?? "")))
						
					default:
						print(url)
						print(data.response)
						print(data.result)
						print(data.request)
						print(String(data: data.data!, encoding: .utf8))
						callback(.failure(.badURL))
					}
				}
			case .failure(_):
				callback(.failure(.badURL))
			}
		}
	}
	internal class func AuthorizedRequest<T: Decodable>(address: String, apiVersion: Int = ApiManager.apiVersion, isOptional: Bool = false, method: HTTPMethod, paramData: Data?, type: T.Type, callback: @escaping (Swift.Result<T,NetworkError>)->()) {
		
		let url = self.url + address
		
		var headers = [
			"content-type": "application/json",
			"cache-control": "no-cache",
			"Api-Version": "\(apiVersion)"]
		if token != ""
		{
			let auth = "Bearer \(token)".replacingOccurrences(of: "\"", with: "")
			headers.updateValue("Authorization", forKey: auth)
		}
		else if isOptional != true && refreshToken == ""
		{
			callback(.failure(.unAuthorized))
		}
		print(String(data: paramData!, encoding: .utf8))
		var request = URLRequest(url: URL(string: url)!)
		request.httpMethod = method.rawValue
		for (i, value) in headers
		{
			request.addValue(value, forHTTPHeaderField: i)
		}
		
		request.httpBody = paramData
		shared.request(request).responseData { (data) in
			
			switch data.response?.statusCode
			{
			case 200:
				guard let stuff = data.data
					else {
						callback(.failure(.badURL))
						return
				}
				let callbackData = try! newJSONDecoder().decode(T.self, from: stuff)
				callback(.success(callbackData))
				
			case 403, 401:
				refreshToken(completion: { (success) in
					if success
					{
						AuthorizedRequest(address: address, isOptional: isOptional, method: method, paramData: paramData, type: type, callback: callback)
					}
					else
					{
						callback(.failure(.tokenExpired))
					}
				})
			case 400:
				guard let stuff = data.data
					else {
						callback(.failure(.badURL))
						return
				}
				let callbackData = try! newJSONDecoder().decode(APIErrorModel.self, from: stuff)
				callback(.failure(.custom(callbackData.message ?? "")))
				
			default:
				print(paramData)
				print(url)
				print(data.response)
				print(data.result)
				print(data.request)
				print(String(data: data.data!, encoding: .utf8))
				callback(.failure(.badURL))
			}
		}
	}
	internal class func AuthorizedRequest(address: String, apiVersion: Int = 2, isOptional: Bool = true, method: HTTPMethod, paramData: Data?, callback: @escaping (Swift.Result<String,NetworkError>)->()) {
		
		let url = self.url + address
		
		var headers =
			["content-type": "application/json",
			"cache-control": "no-cache",
			"Api-Version": "\(apiVersion)"]
		if token != ""
		{
			let auth = "Bearer \(token)".replacingOccurrences(of: "\"", with: "")
			headers.updateValue("Authorization", forKey: auth)
		}
		else if isOptional != true && refreshToken == ""
		{
			callback(.failure(.unAuthorized))
		}
		print(String(data: paramData!, encoding: .utf8))
		var request = URLRequest(url: URL(string: url)!)
		request.httpMethod = method.rawValue
		for (i, value) in headers
		{
			request.addValue(value, forHTTPHeaderField: i)
		}
		request.httpBody = paramData
		shared.request(request).responseData { (data) in
			
			switch data.response?.statusCode
			{
			case 200:
				if let data = data.data
				{
					
					let result = String(data: data, encoding: .utf8)
					callback(.success(result ?? "Success"))
				}
				else
				{
					callback(.success("Success"))
				}
				
			case 403, 401:
				refreshToken(completion: { (success) in
					if success
					{
						AuthorizedRequest(address: address, apiVersion: apiVersion, isOptional: isOptional, method: method, paramData: paramData, callback: callback)
					}
					else
					{
						callback(.failure(.tokenExpired))
					}
				})
			case 400:
				guard let stuff = data.data
					else {
						callback(.failure(.badURL))
						return
				}
				let callbackData = try! newJSONDecoder().decode(APIErrorModel.self, from: stuff)
				print(callbackData.message)
				print(String(data: stuff, encoding: .utf8))
				callback(.failure(.custom(callbackData.message ?? "")))
				
			default:
				print(url)
				print(data.response)
				print(data.result)
				print(data.request)
				print(String(data: data.data!, encoding: .utf8))
				callback(.failure(.badURL))
			}
		}
	}
	internal class func AuthorizedRequest<T: Decodable>(address: String, apiVersion: Int = 2, isOptional: Bool = true, method: HTTPMethod, params: [String:Any]?, type: T.Type, callback: @escaping (Swift.Result<T,NetworkError>)->()) {
		
		let url = self.url + address
		
		var headers = [
			"content-type": "application/json",
			"cache-control": "no-cache",
			"Api-Version": "\(apiVersion)"]
		if token != ""
		{
			let auth = "Bearer \(token)".replacingOccurrences(of: "\"", with: "")
			headers = ["content-type": "application/json",
					   "cache-control": "no-cache",
					   "Api-Version": "\(apiVersion)",
				"Authorization": auth]
		}
		else if isOptional != true && refreshToken == ""
		{
			callback(.failure(.unAuthorized))
		}
		shared.request(url, method: method, parameters: params, encoding: method == .get ? URLEncoding.queryString : JSONEncoding.default, headers: headers).responseData { (data) in
			
			switch data.response?.statusCode
			{
			case 200:
				guard let stuff = data.data
					else {
						callback(.failure(.badURL))
						return
				}
				let callbackData = try! newJSONDecoder().decode(T.self, from: stuff)
				callback(.success(callbackData))
				
			case 403, 401:
				refreshToken(completion: { (success) in
					if success
					{
						AuthorizedRequest(address: address, apiVersion: apiVersion, isOptional: isOptional, method: method, params: params, type: type, callback: callback)
					}
					else
					{
						callback(.failure(.tokenExpired))
					}
				})
			case 400:
				guard let stuff = data.data
					else {
						callback(.failure(.badURL))
						return
				}
				let callbackData = try! newJSONDecoder().decode(APIErrorModel.self, from: stuff)
				callback(.failure(.custom(callbackData.message ?? "")))
				
			default:
				print(headers)
				print(params)
				print(url)
				print(data.response)
				print(data.result)
				print(data.request)
				print(String(data: data.data!, encoding: .utf8))
				callback(.failure(.badURL))
			}
		}
	}
	internal class func AuthorizedRequest(address: String, apiVersion: Int = 2, isOptional: Bool = true, method: HTTPMethod, params: [String:Any]?, callback: @escaping (Swift.Result<String,NetworkError>)->()) {
		
		let url = self.url + address
		
		var headers = [
			"content-type": "application/json",
			"cache-control": "no-cache",
			"Api-Version": "\(apiVersion)"]
		if token != ""
		{
			let auth = "Bearer \(token)".replacingOccurrences(of: "\"", with: "")
			headers =
				["content-type": "application/json",
				"cache-control": "no-cache",
				"Api-Version": "\(apiVersion)",
				"Authorization": auth]
		}
		else if isOptional != true && refreshToken == ""
		{
			callback(.failure(.unAuthorized))
		}
		shared.request(url, method: method, parameters: params, encoding: method == .get ? URLEncoding.queryString : JSONEncoding.default, headers: headers).responseData { (data) in
			
			switch data.response?.statusCode
			{
			case 200:
				if let data = data.data
				{
					
					let result = String(data: data, encoding: .utf8)
					callback(.success(result ?? "Success"))
				}
				else
				{
					callback(.success("Success"))
				}
				
			case 403, 401:
				refreshToken(completion: { (success) in
					if success
					{
						AuthorizedRequest(address: address, apiVersion: apiVersion, isOptional: isOptional, method: method, params: params, callback: callback)
					}
					else
					{
						callback(.failure(.tokenExpired))
					}
				})
			case 400:
				guard let stuff = data.data
					else {
						callback(.failure(.badURL))
						return
				}
				let callbackData = try! newJSONDecoder().decode(APIErrorModel.self, from: stuff)
				callback(.failure(.custom(callbackData.message ?? "")))
				
			default:
				print(params)
				print(url)
				print(data.response)
				print(data.result)
				print(data.request)
				print(String(data: data.data!, encoding: .utf8))
				callback(.failure(.badURL))
			}
		}
	}
	internal class func request(address:String, method: HTTPMethod, shouldAuthorize: Bool = false, apiVersion: Int = 2 , parameters: [String:Any]? ,callback: @escaping (JSON?,Int)->Void) {
		
		let url = self.url + address
		
		var headers: [String: String] = [:]
		if shouldAuthorize
		{
			let auth = "Bearer \(token)".replacingOccurrences(of: "\"", with: "")
			headers = ["content-type": "application/json",
					   "cache-control": "no-cache",
					   "Api-Version": "\(apiVersion)",
				"Authorization": auth]
		}
		else
		{
			headers = ["content-type": "application/json",
					"cache-control": "no-cache",
					"Api-Version": "\(apiVersion)"]
		}
		//let request = URLRequestConvertible()
		var jsonreturn : JSON?
		shared.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
			
			switch response.result{
			case .success:
				
				try! jsonreturn = JSON(data: response.data!)
				callback(jsonreturn!, response.response!.statusCode)
				break
			case .failure(let error):
				callback(nil,503)
				print("Failure error is  :  \(error)")
				print(response)
				print(address)
				break
			}
		}
	}
	class func refreshToken(completion: @escaping (Bool)->Void) {
		
		
		let address = self.url + "Account/refreshToken"
		let headers =
			["content-type": "application/json",
			"cache-control": "no-cache"]
		let params = ["refreshToken": self.refreshToken]
		
		shared.request(address, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).response { (resp) in
			
			if resp.response?.statusCode == 200, let data = resp.data
			{
				DataManager.standard.token = String(data: data, encoding: .ascii)!
				print(self.token)
				completion(true)
			}
			else
			{
				DataManager.standard.logoutUser()
				completion(false)
			}
		}
		
	}
	class func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
		return DataResponseSerializer { _, response, data, error in
			guard error == nil else { return .failure(error!) }
			
			guard let data = data else {
				return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
			}
			
			return Result { try newJSONDecoder().decode(T.self, from: data) }
		}
	}
	
}


func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
