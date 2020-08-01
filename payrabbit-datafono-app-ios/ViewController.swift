//
//  ViewController.swift
//  payrabbit-datafono-app-ios
//
//  Created by Jarturo on 30/07/20.
//  Copyright © 2020 Keos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let sesion_user = UserDefaults.standard;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let state_sesion = sesion_user.bool(forKey: "sesionUserLogin")
        if !state_sesion {
            self.performSegue(withIdentifier: "loginView", sender: self)
        }
        
    }

    @IBAction func logoutButtonTapped(_ sender: Any) {
        
        sesion_user.set(false, forKey: "sesionUserLogin")
        
        self.performSegue(withIdentifier: "loginView", sender: self)
    }
    
}

