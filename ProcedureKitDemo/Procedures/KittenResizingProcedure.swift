//
//  KittenResizeProcedure.swift
//  ProcedureKitDemo
//
//  Created by Jon Shier on 11/5/16.
//  Copyright © 2016 Jon Shier. All rights reserved.
//

import ProcedureKit
import UIKit

class KittenResizeProcedure: Procedure {
    
    typealias ImageCompletionHandler = (_ resultImage: UIImage?) -> Void
    
    let size: CGSize
    let completionHandler: ImageCompletionHandler

    init(size: CGSize, completionHandler: @escaping ImageCompletionHandler) {
        self.size = size
        self.completionHandler = completionHandler
        
        super.init()
    }
    
    override func execute() {
        guard !isCancelled else { return }
        
        defer { finish() }
        
        guard let path = Bundle.main.path(forResource: "BigKitten", ofType: "jpeg"),
              let image = UIImage(contentsOfFile: path) else { return }
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        image.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        DispatchQueue.main.async { self.completionHandler(resizedImage) }
    }
    
}
