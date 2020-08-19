//
//  BankAccountViewController.swift
//  payrabbit-datafono-app-ios
//
//  Created by Jarturo on 12/08/20.
//  Copyright © 2020 Keos. All rights reserved.
//

import UIKit
import Alamofire

class CellClass: UITableViewCell{
    
}

class BankAccountViewController: UIViewController {
    
    @IBOutlet weak var nameUserTextField: UITextField!
    @IBOutlet weak var numDocTextField: UITextField!
    @IBOutlet weak var accountNumTextField: UITextField!
    @IBOutlet weak var docTypeButtom: UIButton!
    @IBOutlet weak var bankButton: UIButton!
    @IBOutlet weak var AccountTypeButton: UIButton!
    
    let transparentView = UIView()
    let tableView = UITableView()
    
    var selectedButton = UIButton()
    var dataSource = [String]()
    
    var docType = ""
    var accountType = ""
    var bankSelected = ""
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
    }
    
    func validarForm(nameUserP: String, numDocP: String, accountNumP: String) {
        if nameUserP == "" || numDocP == "" || accountNumP == "" {
            alertInfo(msg:"Todos los campos son obligatorios")
            return
        }
    }
    
    func alertInfo(msg: String){
        
        let alerta = UIAlertController(title: "Alerta", message: msg, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        
        alerta.addAction(okAction)
        
        self.present(alerta, animated:true, completion:nil)
    }
    
    func addTransparentView(frame: CGRect){
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frame.origin.x, y: frame.origin.y + frame.height, width: frame.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frame.origin.x, y: frame.origin.y + frame.height + 5, width: frame.width, height: CGFloat(self.dataSource.count * 50))
        }, completion: nil)
    }
    
    @objc func removeTransparentView(){
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }

    @IBAction func onClickSelectBank(_ sender: Any) {
        dataSource = ["AV Villas", "Banco Agrario", "Banco Caja Social", "Banco de Bogotá", "Banco de Occidente", "Bancolombia", "BBVA","Citibank",
        "Colpatria", "Corpbanca", "Davivienda", "GNB Sudameris", "Helm Bank", "Popular"]
        selectedButton = bankButton
        addTransparentView(frame: docTypeButtom.frame)
    }
    
    @IBAction func onClickButtonSave(_ sender: Any) {
        
        
        let nameUser = self.nameUserTextField.text!
        let numDoc = self.numDocTextField.text!
        let accountNum = accountNumTextField.text!
        
        let commerce_id = defaults.string(forKey: "commerce_id")
        
        accountType = AccountTypeButton.titleLabel?.text as! String
        docType = docTypeButtom.titleLabel?.text as! String
        bankSelected = bankButton.titleLabel?.text as! String
        
        validarForm(nameUserP:nameUser, numDocP:numDoc, accountNumP:accountNum)
        
        let url_cargue_docs = "https://mybdes.payrabbit.co/commerce/backoffice/bank-account";
        let parametros:Parameters = ["commerce_id": commerce_id, "passwd": "userPwd"];
        NSLog("parametros  %@", parametros)
        
        AF.request(url_cargue_docs, method: .post, parameters: parametros, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
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
    
    @IBAction func onClickSelectDocType(_ sender: Any) {
        dataSource = ["Documento de identidad", "NIT"]
        selectedButton = docTypeButtom
        addTransparentView(frame: docTypeButtom.frame)
    }
    
    @IBAction func onClickSelectAccountType(_ sender: Any) {
        dataSource = ["Cuenta Corriente", "Cuenta de ahorros"]
        selectedButton = AccountTypeButton
        addTransparentView(frame: docTypeButtom.frame)
    }
    
}

extension BankAccountViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dataSelected = dataSource[indexPath.row]
        var buttonSelected = selectedButton
        
        switch dataSelected {
        case "Cuenta Ahorros":
            accountType = "CA"
            break
        case "Cuenta Corriente":
            accountType = "CC"
            break
        case "AV Villas":
            bankSelected = "14"
            break
        case "Banco Agrario":
            bankSelected = "8"
            break
        case "Banco Caja Social":
            bankSelected = "4"
            break
        case "Banco de Bogotá":
            bankSelected = "5"
            break
        case "Banco de Occidente":
            bankSelected = "7"
            break
        case "Bancolombia":
            bankSelected = "3"
            break
        case "BBVA":
            bankSelected = "6"
            break
        case "Citibank ":
            bankSelected = "13"
            break
        case "Colpatria":
            bankSelected = "10"
            break
        case "Corpbanca":
            bankSelected = "15"
            break
        case "Davivienda":
            bankSelected = "2"
            break
        case "GNB Sudameris":
            bankSelected = "12"
            break
        case "Helm Bank":
            bankSelected = "11"
            break
        case "Popular":
            bankSelected = "9"
            break
        case "NIT":
            docType = "9"
        break
        case "Documento de identidad":
            docType = "9"
        break
        default:
            docType = "9"
        }
        selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
        removeTransparentView()
    }
}
