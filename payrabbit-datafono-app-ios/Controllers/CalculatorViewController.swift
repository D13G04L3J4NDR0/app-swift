//
//  CalculatorViewController.swift
//  payrabbit-datafono-app-ios
//
//  Created by Jarturo on 31/07/20.
//  Copyright © 2020 Keos. All rights reserved.
//

import UIKit
import SideMenu

class CalculatorViewController: UIViewController, MenuControllerDelegate {
    
    let sesion_user = UserDefaults.standard;
    @IBOutlet weak var totalButton: UIButton!
    private var menu:SideMenuNavigationController?
    
    private var temp: String = ""
    private var totalNumber: String = ""
    private var totalPayment: String = ""
    private var descriptionPayment: String = ""
    
    @IBOutlet weak var descriptionTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let menuList = MenuListController(with: ["Cargar Documentos","Activar Cuenta Bancaria","Cerrar Sesión"])
        menuList.delegate = self
        
        menu = SideMenuNavigationController(rootViewController: menuList)
        
        SideMenuManager.default.rightMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    @IBAction func didTapMenuButton(){
        print("Menu tapped")
        present(menu!, animated: true)
        
    }
    
    func didSelectMenuItem(name: String) {
        menu?.dismiss(animated: true, completion:{
            [weak self] in
            if name == "Cargar Documentos"{
                print("Cargar Documentos")
            }else if name == "Activar Cuenta Bancaria"{
                print("Activar Cuenta Bancaria")
            }
            else if name == "Cerrar Sesión"{
                self?.sesion_user.set(false, forKey: "sesionUserLogin")
                self?.dismiss(animated:true , completion: nil)
            }
        })
    }
    
    @IBAction func numberAction(_ sender: UIButton){
        temp = temp + String(sender.tag)
        totalButton.setTitle("$"+temp, for: .normal)
    }
    
    @IBAction func decimalAction(_ sender: UIButton){
        let valor_actual = Int(temp)
        temp = String(valor_actual! * sender.tag)
        totalButton.setTitle("$"+temp, for: .normal)
    }
    
    @IBAction func borrarUltimoCaracter(_ sender: UIButton){
        if temp.count > 0 {
            temp = String(temp.dropLast())
            totalButton.setTitle("$"+temp, for: .normal)
        }
        else{
            totalButton.setTitle("$0", for: .normal)
        }
    }
    
    @IBAction func sendPayment(_ sender: Any) {
        print("Clicked Payment Buttom")
        totalPayment = temp
        descriptionPayment = descriptionTextField.text!
        performSegue(withIdentifier: "PayView", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PaymentViewController
        vc.totalPayment = self.totalPayment
        vc.descriptionPayment = self.descriptionPayment
        
    }
}

protocol MenuControllerDelegate {
    func didSelectMenuItem(name:String)
}

class MenuListController: UITableViewController{
    
    public var delegate: MenuControllerDelegate?
    let menuItems: [String]
    
    init(with menuItems: [String]){
        self.menuItems = menuItems
        super.init(nibName: nil, bundle: nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .darkGray
        view.backgroundColor = .darkGray
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .darkGray
        cell.contentView.backgroundColor = .darkGray
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedItem = menuItems[indexPath.row]
        delegate?.didSelectMenuItem(name: selectedItem)
    }
}
