//
//  KittenReadingProcedure.swift
//  ProcedureKitDemo
//
//  Created by Jon Shier on 11/5/16.
//  Copyright © 2016 Jon Shier. All rights reserved.
//

import ProcedureKit
import UIKit

class KittenReadingProcedure: ResultProcedure<UIImage> {
    
    init() {
        super.init {
            guard let path = Bundle.main.path(forResource: "BigKitten", ofType: "jpeg") else {
                throw KittenError.fileNotFound
            }
            
            guard let image = UIImage(contentsOfFile: path) else {
                throw KittenError.invalidImageData
            }
            
            return image
        }
    }
    
}

enum KittenError: Error {
    case fileNotFound, invalidImageData, resizeFailed
}


