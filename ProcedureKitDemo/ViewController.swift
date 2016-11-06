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
        let existenceCondition = KittenExistenceCondition()
        let kittenProcedure = KittenResizeProcedure(size: kittensImageView.bounds.size) { image in
            self.kittensImageView.image = image
        }
        kittenProcedure.add(condition: existenceCondition)
        let queue = ProcedureQueue()
        queue.add(operation: kittenProcedure)
    }

}

