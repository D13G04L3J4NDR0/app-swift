//
//  RegisterPageViewController.swift
//  payrabbit-datafono-app-ios
//
//  Created by Jarturo on 30/07/20.
//  Copyright © 2020 Keos. All rights reserved.
//

import UIKit

class RegisterPageViewController: UIViewController {

    @IBOutlet weak var userNumDocTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPwdTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        
        let userEmail = userEmailTextField.text;
        let userNumDoc = userNumDocTextField.text;
        let userPwd = userPwdTextField.text;
        
        validarCampos(emailText: userEmail!, pwdText: userPwd!, numDocText: userNumDoc!);
        
        let defaults = UserDefaults.standard;
        defaults.set(userEmail, forKey: "UserEmail");
        defaults.set(userPwd, forKey: "UserPwd");
        
        let name = defaults.string(forKey: "UserEmail")
        let pwd = defaults.string(forKey: "UserPwd")
        
        NSLog("User Email %@", name!);
        NSLog("User passwords___ %@", pwd!);
        
        alertSuccess();
    }
    
    func alertMessage(msg:String)
    {
        
        let alerta = UIAlertController(title: "Alerta", message: msg, preferredStyle: UIAlertController.Style.alert);
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil);
        
        alerta.addAction(okAction);
        
        self.present(alerta, animated:true, completion:nil);
        
    }
    
    func validarCampos(emailText:String, pwdText:String, numDocText:String)
    {
        if numDocText == ""
        {
            alertMessage(msg: "El campo Número de documento es obligatorio");
            return;
        }
        if emailText == ""
        {
            alertMessage(msg: "El campo Email es obligatorio");
            
            return;
        }
        if pwdText == ""
        {
            alertMessage(msg: "El campo Contraseña es obligatorio");
            return;
        }
        
    }
    
    func alertSuccess() {
        let alerta = UIAlertController(title: "Alerta", message: "Registro correcto", preferredStyle: UIAlertController.Style.alert);
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default){
            action in self.dismiss(animated: true, completion: nil);
        }
        
        alerta.addAction(okAction);
        
        self.present(alerta, animated:true, completion:nil);
    }
    

}
