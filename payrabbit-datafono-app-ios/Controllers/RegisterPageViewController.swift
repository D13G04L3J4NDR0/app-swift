//
//  RegisterPageViewController.swift
//  payrabbit-datafono-app-ios
//
//  Created by Jarturo on 30/07/20.
//  Copyright © 2020 Keos. All rights reserved.
//

import UIKit
import Alamofire

class RegisterPageViewController: UIViewController {

    @IBOutlet weak var userNumDocTextField: UITextField!
    @IBOutlet weak var DocTypeButtonText: UIButton!
    
    let transparentView = UIView()
    let tableView = UITableView()
    
    var selectedButton = UIButton()
    var dataSource = [String]()
    
    var docType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
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
    @IBAction func onClickDocType(_ sender: Any) {
        dataSource = ["Documento de identidad", "Pasaporte"]
        selectedButton = DocTypeButtonText
        addTransparentView(frame: DocTypeButtonText.frame)
    }

    @IBAction func onClickButtonOK(_ sender: Any) {
        self.performSegue(withIdentifier: "DocumentsRegisterView", sender: self)
    }
}

extension RegisterPageViewController: UITableViewDelegate, UITableViewDataSource{
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
        
        case "Cédula de ciudadania":
            docType = "1"
            break
        default:
            docType = "0"
        }
        selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
        removeTransparentView()
    }
}
