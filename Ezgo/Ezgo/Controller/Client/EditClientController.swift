//
//  EditClientController.swift
//  Ezgo
//
//  Created by Puagnol John on 13/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class EditClientController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var champsMail: UITextField!
    @IBOutlet weak var champsPasseword: UITextField!
    @IBOutlet weak var champsAdresse: UITextField!
    @IBOutlet weak var champsCp: UITextField!
    @IBOutlet weak var champsVille: UITextField!
    @IBOutlet weak var champsPays: UITextField!
    @IBOutlet weak var champsTel: UITextField!
    @IBOutlet weak var buttonValid: UIButton!
    @IBOutlet weak var buttonAnnuler: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var infoClient = [DonneeClient]()
    var idClientTrouver: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonValid.arrondissementBouton()
        buttonAnnuler.arrondissementBouton()
        
        fetchClient()
        
        // C'est ici qu'on recoit les notifications du model
        
        let name = Notification.Name(rawValue: "ConnexionOK")     // Nom de la notification
        NotificationCenter.default.addObserver(self, selector: #selector(pageLoaded) , name: name, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) {
            notification in
            self.keyboardWillShow(notification: notification)
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil){
            notification in
            self.keyboardWillHide(notification: notification)
        }
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(notification: Notification){
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height + 20 , right: 0)
        scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification: Notification){
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        champsMail.resignFirstResponder()
        champsPasseword.resignFirstResponder()
        champsAdresse.resignFirstResponder()
        champsCp.resignFirstResponder()
        champsVille.resignFirstResponder()
        champsPays.resignFirstResponder()
        champsTel.resignFirstResponder()
    }
    
    // event sur la touche retour
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        textField.resignFirstResponder()
        //        return true
        
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    
    
    @objc func pageLoaded(){
        
        // ajout 1 seconde de latence
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.changementView(cible: "storyClient")
        }
    }
    // fonction pour recuperer les données
    func fetchClient() {
        
        // requete pour cibler la données.
        let requete: NSFetchRequest<DonneeClient> = DonneeClient.fetchRequest()
        
        do {
            infoClient = try contexte.fetch(requete)
            
            guard let donnee = infoClient.last?.client else {
                print("No data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(CompteUser.self, from: donnee)
                
                let contenuDico = result.data.head
                
                // on recupere l'adresse client :
                if let prenomClientTrouver = contenuDico.adr1{
                    champsAdresse.text = prenomClientTrouver
                }
                
                // on recupere le cp client :
                if let cpClientTrouver = contenuDico.cp{
                    champsCp.text = cpClientTrouver
                }
                // on recupere la ville client :
                if let villeClientTrouver = contenuDico.ville{
                    champsVille.text = villeClientTrouver
                }
                // on recupere le pays client :
                if let villeClientTrouver = contenuDico.pays{
                    champsPays.text = villeClientTrouver
                }
                
                // on recupere le pays client :
                if let telClientTrouver = contenuDico.tel{
                    champsTel.text = telClientTrouver
                }

                // on recupere le mail client :
                if let mailClientTrouver = contenuDico.email{
                    champsMail.text = mailClientTrouver
                }
                
                champsPasseword.text = "exemple"
                
            } catch {
                print(error)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func modifierAction(_ sender: Any) {
        
        let  champsMailEnvoyer : String = champsMail.text!
        let  champsAdresseEnvoyer : String = champsAdresse.text!
        let  champsCPEnvoyer : String = champsCp.text!
        let  champsVilleEnvoyer : String = champsVille.text!
        let  champsPaysEnvoyer : String = champsPays.text!
        let  champsTelEnvoyer : String = champsTel.text!
        
        UpdateUser.getResponse(idcli: self.idClientTrouver, mail: champsMailEnvoyer, adresse: champsAdresseEnvoyer, cp: champsCPEnvoyer, ville: champsVilleEnvoyer, pays: champsPaysEnvoyer, tel: champsTelEnvoyer )
    }

    
    func changementView(cible : String){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Client", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: cible)
        self.present(nextViewController, animated:true, completion:nil)
    }
}
