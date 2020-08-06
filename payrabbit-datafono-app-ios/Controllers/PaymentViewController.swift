//
//  PaymentViewController.swift
//  payrabbit-datafono-app-ios
//
//  Created by Jarturo on 4/08/20.
//  Copyright © 2020 Keos. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import UIKit

class PaymentViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var totalPaymentLabel: UIButton!
    var totalPayment:String = ""
    private var latitud:Double = 0.0
    private var longitud:Double = 0.0
    var manager:CLLocationManager!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        totalPaymentLabel.setTitle("TOTAL: $"+totalPayment, for: .normal)
        self.getLocation()
        
    }
    
    @IBAction func sendPaymentWsp(_ sender: Any){
        alertInfo(title:"Costo de la transacción" ,msg: "¿Quién asume el costo de la transcción?")
    }
    
    func alertInfo(title:String, msg: String){
        
        
        let alerta = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert);
        let clienteAction = UIAlertAction(title: "El cliente", style: UIAlertAction.Style.default){
            action in self.consultarUrlPayment(cost_buyer:"1")
        }
        let yoAction = UIAlertAction(title: "Yo", style: UIAlertAction.Style.default){
            action in self.consultarUrlPayment(cost_buyer:"0");
        }
        
        alerta.addAction(clienteAction);
        alerta.addAction(yoAction);
        self.present(alerta, animated:true, completion:nil)
    }
    
    func consultarUrlPayment(cost_buyer:String) {
        
        let name = UIDevice().name
        let systemVersion = UIDevice().systemVersion
        let systemName = UIDevice().systemName
        let commerce_id = defaults.string(forKey: "commerce_id")
        let user_id = defaults.string(forKey: "user_id")
        
        let siso = systemName+" "+systemVersion
        
        let url_payment = "https://mybdes.payrabbit.co/payments/paylink/send-payment"
        let parametrosDevice:Parameters = ["lat": latitud, "long": longitud, "device": name, "os": siso]
        
        let parametros:Parameters = ["commerce_id": commerce_id, "source": "2","amount": totalPayment,"test_mode": "1","cost_buyer": cost_buyer,"user_id": user_id,"description": parametrosDevice, "fingerprint": parametrosDevice]
        
        AF.request(url_payment, method: .post, parameters: parametros, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(_):
                
                let jsonResponse = response.value as? [String:Any]
                let code = jsonResponse?["code"] as! Int as Int
                let message = jsonResponse?["message"] as! String
                print(code)
                print(message)
                
                if code == 200{
                    print(jsonResponse)
                    
                    let company = jsonResponse?["company"] as! NSArray
                    let data_company = company[0] as? [String:Any]
                    let brd_tk = data_company?["brd_tk"]
                    let id_company = data_company?["id"]
                    let name_company = data_company?["name"]
                    
                    let sesion_user = UserDefaults.standard;
                    sesion_user.set(jsonResponse?["user_id"], forKey: "user_id")
                    sesion_user.set(brd_tk, forKey: "brd_tk")
                    sesion_user.set(id_company, forKey: "id")
                    sesion_user.set(name_company, forKey: "name")
                    sesion_user.set(true, forKey: "sesionUserLogin")
                    
                    //self.dismiss(animated: true, completion: nil)
                    self.performSegue(withIdentifier: "CalculatorView", sender: self)
                    
                }else if code == 404{
                    print("Sesión incorrecta 404")
                    
                    //self.alertInfo(msg:"Su cuenta o clave son incorrectas o aún no ha confirmado su cuenta de correo.");
                    
                }
                break
                    
                case .failure(let error):
                    print(error)
                break
            }
        }
    }
    
    func getLocation(){
        manager = CLLocationManager()
        manager.delegate = self // Hace el controlador delegado de CLLocationManager
        manager.desiredAccuracy = kCLLocationAccuracyBest // Elige el grado de precisión
        manager.requestAlwaysAuthorization() // Solicita la autorización
        manager.startUpdatingLocation() // Inicia la localización
        
        let permisoLocation = CLLocationManager.authorizationStatus()
        
        if permisoLocation == .notDetermined {
            alertInfo(title: "Error", msg: "Debe activar y permitir datos de localización para realizar el cobro")
        }
        
    }
    
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        guard let newLocation = locations.last else {return}
        
        let userCoord = newLocation.coordinate
        latitud = Double(userCoord.latitude)
        longitud = Double(userCoord.longitude)
        
        print("Coordenadas: latitud:  \(latitud) "+" longitud:  \(longitud)")
    }
}
