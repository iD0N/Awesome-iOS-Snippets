//
//  Color.swift
//  Awesome-iOS-Snippets
//
//  Created by Don on 11/17/19.
//  Copyright © 2019 Don. All rights reserved.
//

import Foundation


extension UIImage {
	
	static func filled(with color: UIColor) -> UIImage {
		let pixelScale = UIScreen.main.scale
		let pixelSize = 1 / pixelScale
		let fillSize = CGSize(width: pixelSize, height: pixelSize)
		let fillRect = CGRect(origin: CGPoint.zero, size: fillSize)
		UIGraphicsBeginImageContextWithOptions(fillRect.size, false, pixelScale)
		let graphicsContext = UIGraphicsGetCurrentContext()
		graphicsContext!.setFillColor(color.cgColor)
		graphicsContext!.fill(fillRect)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image!
	}
	
}
extension UIColor {
	var redValue: CGFloat{ return CIColor(color: self).red }
	var greenValue: CGFloat{ return CIColor(color: self).green }
	var blueValue: CGFloat{ return CIColor(color: self).blue }
	var alphaValue: CGFloat{ return CIColor(color: self).alpha }
	
	static func getGradientColor(from: UIColor, to: UIColor, percentage: CGFloat) -> UIColor {
		precondition(percentage >= 0 && percentage <= 1)
		return UIColor(red: from.redValue + CGFloat(to.redValue - from.redValue) * percentage,
					   green: from.greenValue + CGFloat(to.greenValue - from.greenValue) * percentage,
					   blue: from.blueValue + CGFloat(to.blueValue - from.blueValue) * percentage, alpha: 1.0)
	}
	
    @nonobjc static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0))
    }
}

extension UIColor
{
	
	@nonobjc static func hexStringToUIColor (hex:String) -> UIColor {
		var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
		
		if (cString.hasPrefix("#")) {
			cString.remove(at: cString.startIndex)
		}
		
		if ((cString.count) != 6) {
			return UIColor.gray
		}
		
		var rgbValue:UInt32 = 0
		Scanner(string: cString).scanHexInt32(&rgbValue)
		
		return UIColor(
			red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
			alpha: CGFloat(1.0)
		)
	}
}
