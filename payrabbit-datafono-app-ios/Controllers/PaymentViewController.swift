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
    var descriptionPayment:String = ""
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
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        
        guard let token_sesion = defaults.string(forKey: "token_session")else{return}
        let siso = systemName+" "+systemVersion
        
        let url_payment = "https://mybdes.payrabbit.co/payments/paylink/send-payment"
        let parametrosDevice:Parameters = ["lat": latitud, "long": longitud, "device": name, "os": siso]
        
        do {
            let data = try JSONSerialization.data(withJSONObject: parametrosDevice)
            let paramsDevice = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            
            
            let parametros:Parameters = ["commerce_id": commerce_id, "source": "2","amount": totalPayment,"test_mode": "1","cost_buyer": cost_buyer,"user_id": user_id,"description": descriptionPayment, "fingerprint": paramsDevice]
            
            print(parametros)
            
            let cabeceraHttp: HTTPHeaders = ["X-Payrabbit-Auth": token_sesion, "Content-Type": "application/json; charset=utf-8"]
            AF.request(url_payment, method: .post, parameters: parametros, encoding: JSONEncoding.default, headers: cabeceraHttp).responseJSON { (response) in
                switch response.result {
                case .success(_):
                    
                    let jsonResponse = response.value as? [String:Any]
                    let code = jsonResponse?["code"] as! Int as Int
                    print(code)
                    
                    if code == 200{
                        
                        let jsonResponse = response.value as? [String:Any]
                        let data = jsonResponse?["data"] as! NSDictionary
                        let ticket_number = data["ticket_number"] as! String
                        let amount_due = data["amount_due"] as! Double
                        let mensaje = "Se ha enviado un cobro de: $"+String(amount_due)+", paga de forma segura YA!"
                        let linkPayment = " https://webpayment.payrabbit.co/?token="+ticket_number
                        
                        let msgPayment = mensaje+linkPayment
                        
                        self.sendMsgWsp(msg:msgPayment)
                    }else if code == 404{
                        print("Sesión incorrecta 404")
                    }else if code == 500{
                        print(code)
                    }
                    break
                        
                    case .failure(let error):
                        print(error)
                    break
                }
            }
           
        } catch _ {
        }
        
    }
    
    func sendMsgWsp(msg:String){
        let urlWsp = "whatsapp://send?text=\(msg)"
        if let urlString = urlWsp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            if let wspUrl = NSURL(string: urlString){
                if UIApplication.shared.canOpenURL(wspUrl as URL) {
                    UIApplication.shared.open(wspUrl as URL)
                }
                else{
                    print("Debe instalar WhatsApp")
                    self.alertInfoDos(title: "Advertencia", msg: "Debe instalar Whatsapp")
                }
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
    
    func alertInfoDos(title:String, msg: String){
        
        
        let alerta = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        self.present(alerta, animated:true, completion:nil)
    }
}
