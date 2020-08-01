//
//  CalculatorViewController.swift
//  payrabbit-datafono-app-ios
//
//  Created by Jarturo on 31/07/20.
//  Copyright © 2020 Keos. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    let sesion_user = UserDefaults.standard;

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func logoutButtonTapped(_ sender: Any) {
        print("Button Cerrar Sesión")
        
        sesion_user.set(false, forKey: "sesionUserLogin")
        
        self.dismiss(animated:true , completion: nil)
    }
    
}
