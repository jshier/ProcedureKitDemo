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
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func makeKittens(_ sender: UIButton) {
        let delay = DelayProcedure(by: 2)
        let readingProcedure = KittenReadingProcedure()
        readingProcedure.add(dependency: delay)
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
        
        let group = GroupProcedure(operations: delay, readingProcedure, kittenProcedure, completionProcedure)
        group.addWillExecuteBlockObserver { _ in
            DispatchQueue.main.async { self.activityIndicator.startAnimating() }
        }
        group.addDidFinishBlockObserver { (_, _) in
            DispatchQueue.main.async { self.activityIndicator.stopAnimating() }
        }
        
        let queue = ProcedureQueue()
        queue.add(operation: group)
    }

}

