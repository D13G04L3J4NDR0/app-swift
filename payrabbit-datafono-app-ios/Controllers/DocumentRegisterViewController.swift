//
//  DocumentRegisterViewController.swift
//  payrabbit-datafono-app-ios
//
//  Created by Jarturo on 18/08/20.
//  Copyright © 2020 Keos. All rights reserved.
//

import UIKit

class DocumentRegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickButtonNext(_ sender: Any) {
        
        self.performSegue(withIdentifier: "BussinesRegisterView", sender: self)
    }
}
