//
//  ShinyButton.swift
//
//  Created by Don on 8/18/19.
//  Copyright © 2019 Arvin Alizadeh. All rights reserved.
//
import UIKit
import Foundation

@IBDesignable
class ShinyButton: UIButton {
	
	@IBInspectable var cornerRadius: CGFloat = 8.0
	
	@IBInspectable var shadowOffsetWidth: Int = 0
	@IBInspectable var shadowOffsetHeight: Int = 4
	@IBInspectable var shadowColor: UIColor? = nil
	@IBInspectable var shadowOpacity: Float = 0.4
	@IBInspectable var shadowRadius: CGFloat = 12.0
	
	override func layoutSubviews() {
		super.layoutSubviews()
		if shadowColor == nil
		{
			shadowColor = self.backgroundColor
		}
		layer.cornerRadius = cornerRadius
		let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
		
		layer.masksToBounds = false
		layer.shadowColor = shadowColor?.cgColor
		layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
		layer.shadowOpacity = shadowOpacity
		layer.shadowPath = shadowPath.cgPath
		layer.shadowRadius = shadowRadius
	}
	
}
