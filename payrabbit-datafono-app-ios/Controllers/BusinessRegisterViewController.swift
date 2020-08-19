//
//  BusinessRegisterViewController.swift
//  payrabbit-datafono-app-ios
//
//  Created by Jarturo on 18/08/20.
//  Copyright © 2020 Keos. All rights reserved.
//

import UIKit

class BusinessRegisterViewController: UIViewController {
    
    let transparentView = UIView()
    let tableView = UITableView()
    
    var selectedButton = UIButton()
    var dataSource = [String]()
    
    @IBOutlet weak var docTypeText: UIButton!
    var docType = ""

    @IBOutlet weak var TaxTypeText: UIButton!
    @IBOutlet weak var docTypeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
    }
    
    @IBAction func onClickButtonDocType(_ sender: Any) {
        
        dataSource = ["NIT"]
        selectedButton = docTypeText
        addTransparentView(frame: docTypeText.frame)
    }
    
    @IBAction func onClickButtonTaxType(_ sender: Any) {
        dataSource = ["IVA Regular", "IVA Excluido","IVA Reducido", "IVA Excento","IVA Ampliado"]
        selectedButton = TaxTypeText
        addTransparentView(frame: TaxTypeText.frame)
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
}


extension BusinessRegisterViewController: UITableViewDelegate, UITableViewDataSource{
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
