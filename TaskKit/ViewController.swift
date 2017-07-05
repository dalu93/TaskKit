//
//  ViewController.swift
//  TaskKit
//
//  Created by D'Alberti, Luca on 7/5/17.
//  Copyright © 2017 dalu93. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum Error: Swift.Error {
        case fuck
    }
    
    fileprivate lazy var _task: Task<Int, Error> = self._makeTask()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var times = 0
        _task.then { value in
            print("Got value: \(value)")
        }.catchError { error in
            times += 1
            print("Got error: \(error)")
            return times == 5 ? .stop : .retry
        }.always {
            print("Always called.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func _makeTask() -> Task<Int, Error> {
        return Task { handler in
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                handler.send(error: .fuck)
            }
        }
    }
}

