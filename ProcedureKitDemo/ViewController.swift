//
//  ViewController.swift
//  ProcedureKitDemo
//
//  Created by Jon Shier on 11/5/16.
//  Copyright © 2016 Jon Shier. All rights reserved.
//

import ProcedureKit
import UIKit

class ViewController: UIViewController {

    @IBOutlet var kittensImageView: UIImageView!
    
    @IBAction func makeKittens(_ sender: UIButton) {
        let readingProcedure = KittenReadingProcedure()
        let kittenProcedure = KittenResizeProcedure(size: kittensImageView.bounds.size).injectResult(from: readingProcedure)
        let completionProcedure = KittenCompletionProcedure { (image, error) in
            self.kittensImageView.image = image
            
            // Handle error
        }
        .inject(dependency: kittenProcedure) { (procedure, dependency, errors) in
            guard let resizedImage = dependency.result.value else {
                procedure.error = errors.first
                return
            }
            
            procedure.requirement = .ready(resizedImage)
        }
        
        let queue = ProcedureQueue()
        queue.add(operations: readingProcedure, kittenProcedure, completionProcedure)
    }

}

