//
//  AvatarSettingViewController.swift
//  MR007
//
//  Created by GreatFeat on 29/05/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

class AvatarSettingViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var chooseButton: UIButton!

    @IBAction func chooseImage() {
        let albumSource = UIImagePickerController()
        albumSource.sourceType = .photoLibrary
        albumSource.delegate = self
        self.present(albumSource, animated: true, completion: nil)
    }

    @IBAction func takePhoto() {
        let cameraSource = UIImagePickerController()
        cameraSource.sourceType = .camera
        cameraSource.delegate = self
        self.present(cameraSource, animated: true, completion: nil)
    }
}

// MARK : UIImagePickerControllerDelegate
extension AvatarSettingViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
}

// MARK : UINavigationControllerDelegate
extension AvatarSettingViewController: UINavigationControllerDelegate {

}
