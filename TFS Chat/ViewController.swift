//
//  ViewController.swift
//  TFS Chat
//
//  Created by dmitry on 11.09.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        printStateInfo(#function)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printStateInfo(#function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        printStateInfo(#function)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        printStateInfo(#function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        printStateInfo(#function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        printStateInfo(#function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        printStateInfo(#function)
    }
    
    private func printStateInfo(_ methodName: String) {
        #if DEBUG
        print("Method \(methodName) of ViewController was called \n")
        #endif
    }
    
    
}

