//
//  ScrollView.swift
//  Awesome-iOS-Snippets
//
//  Created by Don on 11/18/19.
//  Copyright © 2019 Don. All rights reserved.
//

import UIKit

extension UIScrollView {
	
	func getContentSize() -> CGSize {
		
		var contentRect = CGRect.zero
		
		for view in self.subviews {
			
			contentRect = contentRect.union(view.frame)
		}
		return contentRect.size
	}
	func resizeToContentSize()
	{
		self.contentSize = self.getContentSize()
	}
}
