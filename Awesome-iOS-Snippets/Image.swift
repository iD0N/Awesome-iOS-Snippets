//
//  Image.swift
//  Awesome-iOS-Snippets
//
//  Created by Don on 11/18/19.
//  Copyright © 2019 Don. All rights reserved.
//

import Foundation

extension UIImage {
    class func ScaleImage(Image : UIImage , maxWidth : CGFloat , maxHeight : CGFloat)->UIImage {
        let raioX = maxWidth / Image.size.width
        let raioY = maxHeight / Image.size.height
        let ratio = min(raioX, raioY)
        
        let newWidth = Image.size.width * ratio
        let newHeight = Image.size.height * ratio
        
        let newimage = self.imageResize(image: Image, scaledToSize: CGSize(width: newWidth, height: newHeight))
        
        return newimage
        
    }
    class func imageResize(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return newImage
        
    }
}
