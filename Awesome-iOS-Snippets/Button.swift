//
//  Button.swift
//  Awesome-iOS-Snippets
//
//  Created by Don on 11/17/19.
//  Copyright © 2019 Don. All rights reserved.
//

import Foundation

public extension UIButton
{
	
	func alignTextUnderImage(spacing: CGFloat = 6.0)
	{
		if let image = self.imageView?.image
		{
			let imageSize: CGSize = image.size
			self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
			let labelString = NSString(string: self.titleLabel!.text!)
			let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font])
			self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
		}
	}
}
