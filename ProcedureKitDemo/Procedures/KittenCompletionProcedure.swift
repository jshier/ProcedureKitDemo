//
//  KittenCompletionProcedure.swift
//  ProcedureKitDemo
//
//  Created by Jon Shier on 11/5/16.
//  Copyright © 2016 Jon Shier. All rights reserved.
//

import ProcedureKit
import UIKit

class KittenCompletionProcedure: Procedure, ResultInjection {

    var requirement: PendingValue<UIImage> = .pending
    var result: PendingValue<Void> = .void
    
    var error: Error?
    
    typealias ImageCompletionHandler = (_ resizedImage: UIImage?, _ error: Error?) -> Void
    
    let completionHandler: ImageCompletionHandler
    
    init(completionHandler: @escaping ImageCompletionHandler) {
        self.completionHandler = completionHandler
        super.init()
    }
    
    override func execute() {
        guard !isCancelled else { return }
        
        DispatchQueue.main.async { self.completionHandler(self.requirement.value, self.error) }
        finish()
    }
    
}
