//
//  KittenExistenceCondition.swift
//  ProcedureKitDemo
//
//  Created by Jon Shier on 11/5/16.
//  Copyright © 2016 Jon Shier. All rights reserved.
//

import ProcedureKit
import UIKit

class KittenExistenceCondition: Condition {
    
    enum KittenExistenceError: Error {
        case fileNotFound, invalidImageData
    }
    
    override func evaluate(procedure: Procedure, completion: @escaping (ConditionResult) -> Void) {
        guard let path = Bundle.main.path(forResource: "BigKitten", ofType: "jpeg") else {
            completion(.failed(KittenExistenceError.fileNotFound))
            return
        }
        
        guard let _ = UIImage(contentsOfFile: path) else {
            completion(.failed(KittenExistenceError.invalidImageData))
            return
        }
        
        completion(.satisfied)
    }
    
}
