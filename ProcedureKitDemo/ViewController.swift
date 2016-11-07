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
        let completionHandler: (_ resizedImage: UIImage?, _ errors: [Error]?) -> Void = { (image, errors) in
            if let errors = errors, !errors.isEmpty {
                // Handle errors
                return
            }
            
            DispatchQueue.main.async { self.kittensImageView.image = image }
        }
        kittenProcedure.addDidFinishBlockObserver { (resizeProcedure, errors) in
            completionHandler(resizeProcedure.result.value, errors)
        }
        
        let group = GroupProcedure(operations: delay, readingProcedure, kittenProcedure)
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

