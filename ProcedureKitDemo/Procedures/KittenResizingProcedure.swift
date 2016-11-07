//
//  KittenResizeProcedure.swift
//  ProcedureKitDemo
//
//  Created by Jon Shier on 11/5/16.
//  Copyright © 2016 Jon Shier. All rights reserved.
//

import ProcedureKit
import UIKit

class KittenResizeProcedure: TransformProcedure<UIImage, UIImage> {
    
    init(size: CGSize) {
        super.init { inputImage in
            UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
            defer { UIGraphicsEndImageContext() }
            inputImage.draw(in: CGRect(origin: .zero, size: size))
            guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext() else {
                throw KittenError.resizeFailed
            }

            return resizedImage
        }
    }
    
}
