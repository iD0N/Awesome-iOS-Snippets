//
//  Textview.swift
//  Don
//
//  Created by Don on 3/13/20.
//  Copyright © 2020 Don. All rights reserved.
//

import UIKit

@IBDesignable
class TextView: UITextView {
	
	@IBInspectable var cornerRadius: CGFloat = 10.0
	
	@IBInspectable var shadowOffsetWidth: Int = 0
	@IBInspectable var shadowOffsetHeight: Int = 2
	@IBInspectable var shadowColor: UIColor? = UIColor.black
	@IBInspectable var shadowOpacity: Float = 0.1
	@IBInspectable var shadowRadius: CGFloat = 10.0
	
	@IBInspectable var placeholderText: String = ""
	@IBInspectable var placeHolderColor: UIColor = UIColor.black.withAlphaComponent(0.3)
	
	var mainColor: UIColor?
	override var text: String! {
		didSet {
			if text == "" || text == placeholderText {
				self.textColor = placeHolderColor
			}
			else
			{
				self.textColor = mainColor
			}
		}
	}
	override func layoutSubviews() {
		
		super.layoutSubviews()
		
		layer.cornerRadius = cornerRadius
		let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
		
		layer.masksToBounds = false
		layer.shadowColor = shadowColor?.cgColor
		layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
		layer.shadowOpacity = shadowOpacity
		layer.shadowPath = shadowPath.cgPath
		layer.shadowRadius = shadowRadius
	}
	override func awakeFromNib() {
		super.awakeFromNib()
		if text == ""
		{
			self.text = placeholderText
			self.textColor = placeHolderColor
		}
	}
    private func commonInit() {
        contentMode = .redraw
		NotificationCenter.default.addObserver(self, selector: #selector(textDidEndEditing(_:)), name: UITextView.textDidEndEditingNotification, object: self)
		NotificationCenter.default.addObserver(self, selector: #selector(textDidBeginEditting(_:)), name: UITextView.textDidBeginEditingNotification, object: self)
		self.mainColor = self.textColor
		self.textContainerInset = UIEdgeInsets(top: 8.0, left: 20.0, bottom: 8.0, right: 20.0)
    }
    
	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
	func setText(text: String) {
		if textColor == placeHolderColor && text == placeholderText
		{
			self.text = text
			self.textColor = mainColor
		}
	}
	
    // Trim white space and new line characters when end editing.
    @objc func textDidEndEditing(_ notification: Notification) {
        if let sender = notification.object as? TextView, sender == self {
			if textColor == mainColor && text == ""
			{
				self.text = placeholderText
				self.textColor = placeHolderColor
			}
        }
    }
    
    // Limit the length of text
    @objc func textDidBeginEditting(_ notification: Notification) {
        if let sender = notification.object as? TextView, sender == self {
			if textColor == placeHolderColor && text == placeholderText
			{
				self.text = ""
				self.textColor = mainColor
			}
        }
    }
	
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		if text == ""
		{
			text = placeholderText
			textColor = placeHolderColor
		}
	}
}
