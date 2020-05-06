//
//  Font.swift
//  Awesome-iOS-Snippets
//
//  Created by Don on 11/17/19.
//  Copyright © 2019 Don. All rights reserved.
//

import Foundation


enum UserFonts: String
{
	case iranSans = "IRANSansMobileFaNum"
	case montserrat = "montserrat"
}
extension UIFont {
	static func AryaFont(withSize size: CGFloat = 14) -> UIFont
	{
		return UIFont.init(name: "montserrat", size: size)!
	}
    class func IranSans(withsize size:CGFloat = 15)->UIFont{
		
        return UIFont.init(name: "IRANSansMobileFaNum", size: size)!
    }
}
