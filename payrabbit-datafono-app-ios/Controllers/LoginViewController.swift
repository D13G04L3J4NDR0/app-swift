//
//  LoginViewController.swift
//  payrabbit-datafono-app-ios
//
//  Created by Jarturo on 31/07/20.
//  Copyright © 2020 Keos. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPwdTextField: UITextField!
    var jsonArray: NSArray?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        let userEmail = userEmailTextField.text;
        let userPwd = userPwdTextField.text;
        
        validarCampos(email:userEmail!, pwd:userPwd!);
            
        let url_login = "https://mybdes.payrabbit.co/commerce/auth/login";
        let parametros:Parameters = ["email": userEmail, "passwd": userPwd];
        NSLog("parametros  %@", parametros)
        
        AF.request(url_login, method: .post, parameters: parametros, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                
                let jsonResponse = response.value as? [String:Any]
                let code = jsonResponse?["code"] as! Int as Int
                let message = jsonResponse?["message"] as! String
                print(code)
                print(message)
                
                if code == 200{
                    print(jsonResponse)
                    
                    let headersResponse = response.response?.allHeaderFields["X-Payrabbit-Auth"]
                    print(headersResponse)
                    
                    let company = jsonResponse?["company"] as! NSArray
                    let data_company = company[0] as? [String:Any]
                    let brd_tk = data_company?["brd_tk"]
                    let id_company = data_company?["id"]
                    let name_company = data_company?["name"]
                    
                    let user_id = jsonResponse?["user_id"]
                    
                    let sesion_user = UserDefaults.standard;
                    sesion_user.set(headersResponse, forKey: "token_session")
                    sesion_user.set(user_id, forKey: "user_id")
                    sesion_user.set(brd_tk, forKey: "brd_tk")
                    sesion_user.set(id_company, forKey: "commerce_id")
                    sesion_user.set(name_company, forKey: "name")
                    sesion_user.set(true, forKey: "sesionUserLogin")
                    
                    //self.dismiss(animated: true, completion: nil)
                    self.performSegue(withIdentifier: "CalculatorView", sender: self)
                    
                }else if code == 404{
                    print("Sesión incorrecta 404")
                    self.alertInfo(msg:"Su cuenta o clave son incorrectas o aún no ha confirmado su cuenta de correo.")
                }
                
                break
                    
                case .failure(let error):
                    print(error)
                break
            }
        }
    }
    
    func validarCampos (email:String, pwd:String){
        if email == "" || pwd == "" {
            alertInfo(msg:"Digite email y contraseña")
            return
        }
    }
    
    func alertInfo(msg: String){
        
        let alerta = UIAlertController(title: "Alerta", message: msg, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        
        alerta.addAction(okAction)
        
        self.present(alerta, animated:true, completion:nil)
    }
    

}
