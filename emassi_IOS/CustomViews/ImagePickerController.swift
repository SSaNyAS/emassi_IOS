//
//  ImagePickerController.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 26.09.2022.
//

import Foundation
import UIKit

public class ImagePickerController: UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    public var didSelectImageAction: ((UIImage) -> Void)?
    public var didCancelPickImage: (()->Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        didCancelPickImage?()
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = ((info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage)){
            didSelectImageAction?(image)
            dismiss(animated: true)
        }
    }
}
