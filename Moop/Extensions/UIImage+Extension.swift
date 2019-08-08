//
//  UIImage+Extension.swift
//  Moop
//
//  Created by kor45cw on 08/08/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit

extension UIImage {
    var gray: UIImage? {
        guard let currentCGImage = self.cgImage else { return nil }
        let currentCIImage = CIImage(cgImage: currentCGImage)

        let filter = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(currentCIImage, forKey: "inputImage")

        // set a gray value for the tint color
        filter?.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: "inputColor")

        filter?.setValue(1.0, forKey: "inputIntensity")
        guard let outputImage = filter?.outputImage else { return nil}

        let context = CIContext()

        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            return processedImage
        }
        return nil
    }
}
