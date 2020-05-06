//
//  CardMessages.swift
//  Chamedonam
//
//  Created by Don on 8/26/19.
//  Copyright © 2019 Arvin Alizadeh. All rights reserved.
//

import Foundation
import SwiftEntryKit

class CardMessages
{
	
	class func showErrorMessage(title: String = "خطا", description: String) {
		var attributes = EKAttributes.topFloat
		attributes.entryBackground = .gradient(gradient: .init(colors: [.init(UIColor.mango), .init(UIColor.grapefruit)], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
		attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
		attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
		attributes.statusBar = .dark
		attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
		attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.bounds.width), height: .intrinsic)
		
		let title = EKProperty.LabelContent(text: title, style: .init(font: UIFont.chamedonamBoldFont(ofSize: 18), color: .white))
		let description = EKProperty.LabelContent(text: description, style: .init(font: UIFont.chamedonamFont(ofSize: 16), color: .white))
		let simpleMessage = EKSimpleMessage(title: title, description: description)
		let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
		
		let contentView = EKNotificationMessageView(with: notificationMessage)
		SwiftEntryKit.display(entry: contentView, using: attributes)
	}
	
	class func showAlertView(title: String, description: String, okButtonTitle: String, closeButtonTitle: String, okClosure: @escaping ()->Void) {
		
		var attributes = EKAttributes.centerFloat
		attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
		//attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
		attributes.shadow = .none
		attributes.scroll = .edgeCrossingDisabled(swipeable: true)
		attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.bounds.width), height: .intrinsic)
		attributes.displayDuration = .infinity
		attributes.entryBackground = .gradient(gradient: .init(colors: [.init(UIColor.mango), .init(UIColor.grapefruit)], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
		attributes.screenBackground = .color(color: .init(.veryLightPinkFour))
		attributes.screenInteraction = .dismiss
		attributes.entryInteraction = .absorbTouches
		attributes.hapticFeedbackType = .warning
		attributes.windowLevel = .statusBar
		
		let title = EKProperty.LabelContent(
			text: title,
			style: .init(
				font: UIFont.chamedonamBoldFont(ofSize: 16),
				color: .black,
				alignment: .center))
		let description = EKProperty.LabelContent(
			text: description,
			style: .init(
				font: UIFont.chamedonamFont(ofSize: 14),
				color: .black,
				alignment: .center))
		let simpleMessage = EKSimpleMessage(
			title: title,
			description: description)
		let buttonFont = UIFont.chamedonamBoldFont(ofSize: 16)
		let closeButtonLabelStyle = EKProperty.LabelStyle(
			font: buttonFont,
			color: .white)
		
		let closeButtonLabel = EKProperty.LabelContent(
			text: closeButtonTitle,
			style: closeButtonLabelStyle)
		let closeButton = EKProperty.ButtonContent(
			label: closeButtonLabel,
			backgroundColor: .clear,
			highlightedBackgroundColor: .init(UIColor.brownGrey.withAlphaComponent(0.05))) {
				SwiftEntryKit.dismiss()
		}
		let okButtonLabelStyle = EKProperty.LabelStyle(
			font: buttonFont,
			color: .init(.dustyBlue)
		)
		let okButtonLabel = EKProperty.LabelContent(
			text: okButtonTitle,
			style: okButtonLabelStyle
		)
		let okButton = EKProperty.ButtonContent(
			label: okButtonLabel,
			backgroundColor: .clear,
			highlightedBackgroundColor: .init(UIColor.dustyBlue.withAlphaComponent(0.05))) {
				
				okClosure()
				SwiftEntryKit.dismiss()
		}
		
		let buttonsBarContent = EKProperty.ButtonBarContent(
			with: okButton, closeButton,
			separatorColor: .init(UIColor.white),
			expandAnimatedly: true
		)
		let alertMessage = EKAlertMessage(
			simpleMessage: simpleMessage,
			buttonBarContent: buttonsBarContent
		)
		let contentView = EKAlertMessageView(with: alertMessage)
		SwiftEntryKit.display(entry: contentView, using: attributes)
		
	}
}
