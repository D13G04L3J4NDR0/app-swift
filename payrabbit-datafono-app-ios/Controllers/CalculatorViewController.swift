//
//  CalculatorViewController.swift
//  payrabbit-datafono-app-ios
//
//  Created by Jarturo on 31/07/20.
//  Copyright © 2020 Keos. All rights reserved.
//

import UIKit
import SideMenu

class CalculatorViewController: UIViewController {
    let sesion_user = UserDefaults.standard;
    @IBOutlet weak var totalButton: UIButton!
    var menu: SideMenuNavigationController?
    
    private var temp: String = ""
    private var totalNumber: String = ""
    private var totalPayment: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menu = SideMenuNavigationController(rootViewController: UIViewController())
        SideMenuManager.default.rightMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        print("Button Cerrar Sesión")
        
        sesion_user.set(false, forKey: "sesionUserLogin")
        self.dismiss(animated:true , completion: nil)
    }
    
    @IBAction func didTapMenu(){
        present(menu!, animated: true)
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
        performSegue(withIdentifier: "PaymentView", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PaymentViewController
        vc.totalPayment = self.totalPayment
    }
}

class MenuListController: UITableViewController{
    var items = ["Cargar documentos", "Activar cuenta bancaria"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
}
