//
//  KittenReadingProcedure.swift
//  ProcedureKitDemo
//
//  Created by Jon Shier on 11/5/16.
//  Copyright © 2016 Jon Shier. All rights reserved.
//

import ProcedureKit
import UIKit

class KittenReadingProcedure: Procedure, ResultInjection {

    var requirement: PendingValue<Void> = .void
    var result: PendingValue<UIImage> = .pending
    
    var image: UIImage? {
        return result.value
    }

    override func execute() {
        guard !isCancelled else { return }
        
        var error: Error? = nil
        defer { finish(withError: error) }
        
        guard let path = Bundle.main.path(forResource: "BigKitten", ofType: "jpeg") else {
            error = KittenError.fileNotFound
            return
        }
        
        guard let image = UIImage(contentsOfFile: path) else {
            error = KittenError.invalidImageData
            return
        }
        
        result = .ready(image)
    }
    
}

enum KittenError: Error {
    case fileNotFound, invalidImageData, resizeFailed
}


