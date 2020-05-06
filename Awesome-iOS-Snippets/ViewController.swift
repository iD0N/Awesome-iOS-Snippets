//
//  ViewController.swift
//  Awesome-iOS-Snippets
//
//  Created by Don on 11/9/19.
//  Copyright © 2019 Don. All rights reserved.
//


extension UIViewController
{

	//TODO: ADD ALIGNMENT ARGUMENT IMPELEMNTATION
	func addRightAlignedTitle(title: String, alignment: NSTextAlignment) {
		
		let view = ChatTopView()
		let label = UILabel()
		label.text = title
		label.font = UIFont.chamedonamBoldFont(ofSize: 26)
		label.textAlignment = .right
		
		label.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(label)
		let trailing = NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -12)
		
		let bottom = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
		view.addConstraints([bottom, trailing])
		
		
		self.navigationItem.titleView = view
	}
}

