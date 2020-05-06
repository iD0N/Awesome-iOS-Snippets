//
//  Textfield.swift
//  Don
//
//  Created by Don on 2/11/20.
//  Copyright © 2020 Don. All rights reserved.
//

import UIKit


@IBDesignable
class Textfield: UITextField, TextValidatable {
	
	@IBInspectable var mainIconImage: UIImage?
	@IBInspectable var secodaryIconImage: UIImage?
	
	@IBInspectable var cornerRadius: CGFloat = 10.0
	@IBInspectable var shadowOffsetWidth: Int = 0
	@IBInspectable var shadowOffsetHeight: Int = 2
	@IBInspectable var shadowColor: UIColor? = UIColor.black
	@IBInspectable var shadowOpacity: Float = 0.1
	@IBInspectable var shadowRadius: CGFloat = 10.0
	
	
	
	@IBInspectable var textLength: Int = 0
	
	var paddingSize: CGFloat = 20.0
	@IBInspectable var minTextLength: Int = 0
	var formatter: TextFormatters?
	@IBInspectable var formatStyle: String = ""
	///Validated text
	var validatedText: String? {
		get {
			let result = formatter?.validate(text) ?? text ?? ""
			return result.count >= minTextLength ? result : ""
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
		addPaddings()
		setupValidatable()
		
	}
	override func deleteBackward() {
		if formatter == nil {
			super.deleteBackward()
			return
		}
		text = ValidatableDeleteLast(text)
	}
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }

    @objc private func applyFormat() {
		
		text = applyFormatting(to: text)
	}
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		addPaddings()
	}
	internal func addPaddings() {
		
		var mainIcon: UIButton?
		var secodaryIcon: UIButton?
		
		if(mainIconImage != nil)
		{
			mainIcon = UIButton(frame: CGRect(x: 10, y: 0, width: 30.0 + paddingSize*2, height: 30))
			mainIcon?.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
			mainIcon?.contentMode = .scaleAspectFit
			mainIcon?.setImage(mainIconImage!, for: .normal)
		}
		if(secodaryIconImage != nil)
		{
			secodaryIcon = UIButton(frame: CGRect(x: 10, y: 0, width: 30.0 + paddingSize*2, height: 30))
			secodaryIcon?.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
			secodaryIcon?.contentMode = .scaleAspectFit
			secodaryIcon?.setImage(secodaryIconImage!, for: .normal)
		}
		if textAlignment != .right
		{
			self.leftView = mainIcon ?? UIView(frame: CGRect(x: 0, y: 0, width: paddingSize, height: paddingSize))
			self.leftViewMode = .always
			self.rightView = secodaryIcon ?? UIView(frame: CGRect(x: 0, y: 0, width: paddingSize, height: paddingSize))
			self.rightViewMode = .always
		}
		else
		{
			self.rightView = mainIcon ?? UIView(frame: CGRect(x: 0, y: 0, width: paddingSize, height: paddingSize))
			self.leftViewMode = .always
			self.leftView = secodaryIcon ?? UIView(frame: CGRect(x: 0, y: 0, width: paddingSize, height: paddingSize))
			self.rightViewMode = .always
		}
	}
}


protocol TextValidatable {
	
	
	var textLength: Int
	
	var paddingSize: CGFloat
	var minTextLength: Int
	var formatter: TextFormatters?
	var formatStyle: String
	///Validated text
	var validatedText: String?
	@objc func applyFormat()
	
}
extension TextValidatable
{

	func setupValidatable() {
		
		switch formatStyle {
		case "credit":
			formatter = .creditCard
		case "number":
			formatter = .number
		case "price":
			formatter = .price
		default:
			break
		}
		
		if (textLength > 0) || (formatter != nil)
		{
			addTarget(self, action: #selector(applyFormat), for: .editingChanged)
		}
	}
	func ValidatableDeleteLast(_ text: String?) -> String? {
		
		guard let formatter = formatter else {
			return text
		}
		var cleaned = formatter.validate(text)
		guard cleaned.count > 0 else { return }
		cleaned.removeLast()
		return formatter.format(cleaned)
	}
	private func applyFormatting(to text: String?) -> String? {
		
		guard let edit = text, textLength > 0 else {
			if let formatter = formatter
			{
				return formatter.format(text?.cleanNumber())
			}
		}
		if let formatter = formatter
		{
			let lengthAppliedText = String(edit.cleanNumber().prefix(textLength))
			return formatter.format(lengthAppliedText)
		}
		else
		{
			return String(edit.prefix(textLength))
		}
	}
}
