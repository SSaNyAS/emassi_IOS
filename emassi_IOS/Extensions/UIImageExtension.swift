//
//  UIImageExtension.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 26.09.2022.
//

import Foundation
import UIKit.UIImage

extension UIImage{
    static var noPhotoUser: UIImage?{
        return UIImage(named: "nophotouser")
    }
    
    func compressedData(targetSize: CGSize = .init(width: 400, height: 400)) -> Data?{
        let resizedImage = self.resizeImage(targetSize: targetSize)
        
        let jpegData = resizedImage?.jpegData(compressionQuality: 0.8)
        return jpegData
    }
    
    func resizeImage(targetSize: CGSize) -> UIImage? {
        let image = self
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
