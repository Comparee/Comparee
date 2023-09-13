//
//  CropViewController.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/12/23.
//

import CropViewController
import UIKit

final class UploadCropViewController: CropViewController {
    
    override init(image: UIImage) {
        super.init(croppingStyle: .default, image: image)
        self.aspectRatioPreset = .preset4x3
        self.aspectRatioLockEnabled = true
        self.aspectRatioPickerButtonHidden = true
        self.toolbarPosition = .bottom
        self.doneButtonTitle = "Continue"
        self.cancelButtonTitle = "Back"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
