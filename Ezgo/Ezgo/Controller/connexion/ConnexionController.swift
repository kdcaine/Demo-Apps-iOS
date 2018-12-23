//
//  ConnexionController.swift
//  Ezgo
//
//  Created by Puagnol John on 22/10/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit
import Foundation

class ConnexionController: UIViewController {

    var codeClient: String!
    
    @IBOutlet weak var cardConnectButton: UIButton!
    
    @IBOutlet weak var cardTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var errorMsg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        
        // Arrondissement des boutons et ajout du shadows
        arrondissement(bouton: cardConnectButton)
        
        print("code barre")
        print(codeClient)
        cardTextField.text = codeClient
        
        // C'est ici qu'on recoit les notifications du model
        
        let name = Notification.Name(rawValue: "ConnexionOK")     // Nom de la notification
        NotificationCenter.default.addObserver(self, selector: #selector(pageLoaded) , name: name, object: nil)
    }
    
    
    @IBAction func cacheClavier(_ sender: UITapGestureRecognizer) {
        cardTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    
    @objc func pageLoaded(){
        
        // ajout 1 seconde de latence
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.changementView(cible: "storyClient")
        }
    }
    
    @IBAction func cardConnectAction(_ sender: Any) {
        
        
        // test si le champs n'est pas vide pr carte client
        if let text1 = cardTextField.text, !text1.isEmpty{
            let  champsCard : String = cardTextField.text!
            
            if isValidEmail(email: champsCard) {
                loading.startAnimating()
                Connexion.getResponse(idco: champsCard, choixCo: 2) { (result) -> () in        // type mail
                    
                    guard let etatFind = result["etat"] else {
                        print("No data")
                        return
                    }
                    
                    guard let numFind = result["erreur"] else {
                        print("No data")
                        return
                    }
                    
                    let etat:Bool = etatFind as! Bool
                    let errorNumber: Int = numFind as! Int
                    
                    if !etat {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.errorMsg.isHidden = false
                            let errorStatutMSG = "ERROR_MESSAGE_" + String(errorNumber)
                            self.errorMsg.text =  NSLocalizedString(errorStatutMSG, comment: "")
                            self.loading.isHidden = true
                        }
                    }
                }
            }
            
            if champsCard.isNumber {
                loading.startAnimating()
                Connexion.getResponse(idco: champsCard, choixCo: 1) { (result) -> () in
                    guard let etatFind = result["etat"] else {
                        print("No data")
                        return
                    }
                    
                    guard let numFind = result["erreur"] else {
                        print("No data")
                        return
                    }
                    
                    let etat:Bool = etatFind as! Bool
                    let errorNumber: Int = numFind as! Int
                    
                    if !etat {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.errorMsg.isHidden = false
                            let errorStatutMSG = "ERROR_MESSAGE_" + String(errorNumber)
                            self.errorMsg.text =  NSLocalizedString(errorStatutMSG, comment: "")
                            self.loading.isHidden = true
                        }
                    }
                }        // 9200999846295
            }
            
            
        }
        else {
            errorMsg.isHidden = false
            errorMsg.text = "Veuillez entrer vos identifiants !"
            print("champs vide")
        }
        
    }
    
    // validate an email for the right format
    func isValidEmail(email:String?) -> Bool {
        
        guard email != nil else { return false }
        
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }
    
    func arrondissement(bouton : UIButton) {
        bouton.layer.cornerRadius = 15
        bouton.layer.shadowColor = UIColor.lightGray.cgColor
        bouton.layer.shadowOffset = CGSize(width: 5, height: 5)
        bouton.layer.shadowRadius = 2
        bouton.layer.shadowOpacity = 1.0
    }
    
    func changementView(cible : String){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Client", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: cible)
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    
}
