//
//  KittenResizeProcedure.swift
//  ProcedureKitDemo
//
//  Created by Jon Shier on 11/5/16.
//  Copyright © 2016 Jon Shier. All rights reserved.
//

import ProcedureKit
import UIKit

class KittenResizeProcedure: Procedure, ResultInjection {
    
    var requirement: PendingValue<UIImage> = .pending
    var result: PendingValue<UIImage> = .pending
    
    var resizedImage: UIImage? {
        return result.value
    }
    
    let size: CGSize

    init(size: CGSize) {
        self.size = size
        
        super.init()
    }
    
    override func execute() {
        guard !isCancelled else { return }
        
        var error: Error? = nil
        defer { finish(withError: error) }
        
        guard let inputImage = requirement.value else {
            error = ProcedureKitError.requirementNotSatisfied()
            return
        }
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        defer { UIGraphicsEndImageContext() }
        inputImage.draw(in: CGRect(origin: .zero, size: size))
        guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            error = KittenError.resizeFailed
            return
        }
        
        result = .ready(resizedImage)
    }
    
}
