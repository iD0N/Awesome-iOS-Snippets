//
//  UIView.swift
//  Awesome-iOS-Snippets
//
//  Created by Don on 11/17/19.
//  Copyright © 2019 Don. All rights reserved.
//

import Foundation


extension UIView
{
	@IBInspectable var cornerRadiusValue: CGFloat {
		get {
			return self.layer.cornerRadius
		}
		set
		{
			self.layer.cornerRadius = newValue
		}
	}
	@IBInspectable var borderColorValue: UIColor? {
		get {
			return layer.borderColor.map(UIColor.init)
		}
		set {
			layer.borderColor = newValue?.cgColor
		}
	}
	@IBInspectable var borderWidthValue: CGFloat {
		get {
			return layer.borderWidth
		}
		set {
			layer.borderWidth = newValue
		}
	}
	
	
	var parentViewController: UIViewController?
	{
		var parentResponder: UIResponder? = self
		while parentResponder != nil {
			parentResponder = parentResponder!.next
			if let viewController = parentResponder as? UIViewController {
				return viewController
			}
		}
		return nil
	}
}

