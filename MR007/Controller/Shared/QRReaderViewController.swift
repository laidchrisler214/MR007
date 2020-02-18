//
//  QRReaderViewController.swift
//  MR007
//
//  Created by Roger Molas on 23/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import AVFoundation

class QRReaderViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var currentImage: UIImage? = nil

    fileprivate var borderDetectionFrameColor: UIColor = UIColor(red:0.2, green:0.26, blue:0.6, alpha:0.5)

    /// Object Detector
    fileprivate lazy var objectDetector:CIDetector = {
        let detector:CIDetector = CIDetector(ofType: CIDetectorTypeQRCode,
                                             context:nil,
                                             options:[CIDetectorAccuracy: CIDetectorAccuracyHigh])!
        return detector
    }()

    func isInstalled() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string:"weixin://")!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = currentImage
        _ = self.readImage(inputImage: self.imageView.image!)
    }

    func readImage(inputImage: UIImage) {
        let image = CIImage(image: inputImage)
        var resultImage: CIImage? = nil
        var decode = ""
        let features = objectDetector.features(in: image!)
        for feature in (features as? [CIQRCodeFeature])! {
            resultImage = self.overlayImageForFeatureInImage(image: image!, feature: feature)
            decode = feature.messageString!
        }
        print("QR Code: \(decode)")
        self.imageView.image = UIImage(ciImage: resultImage!)
        if self.isInstalled() {
            UIApplication.shared.open(URL(string: decode)!, options: ["qr":"read"], completionHandler: nil)
        } else {
            UIApplication.shared.open(URL(string: "itms://itunes.com/apps/weixin")!, options: ["qr":"app"], completionHandler: nil)
        }
    }

    // MARK: Overlay image
    private func overlayImageForFeatureInImage(image: CIImage, feature: CIQRCodeFeature) -> CIImage! {
        var overlay = CIImage(color: CIColor(color: self.borderDetectionFrameColor))
        overlay = overlay.cropping(to: image.extent)
        overlay = overlay.applyingFilter("CIPerspectiveTransformWithExtent",
                                         withInputParameters:["inputExtent": CIVector(cgRect:image.extent),
                                                              "inputTopLeft": CIVector(cgPoint: feature.topLeft),
                                                              "inputTopRight":   CIVector(cgPoint: feature.topRight),
                                                              "inputBottomLeft": CIVector(cgPoint: feature.bottomLeft),
                                                              "inputBottomRight": CIVector(cgPoint: feature.bottomRight)])
        return image.cropping(to: overlay.extent)
    }
}
