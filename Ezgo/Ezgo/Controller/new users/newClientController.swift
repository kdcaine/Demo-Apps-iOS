//
//  newClientController.swift
//  Ezgo
//
//  Created by Puagnol John on 19/10/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit

class newClientController: UIViewController {

    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nomTextField: UITextField!
    @IBOutlet weak var prenomTextField: UITextField!
    @IBOutlet weak var adresseTextField: UITextField!
    @IBOutlet weak var codePostalTextField: UITextField!
    @IBOutlet weak var villeTextField: UITextField!
    @IBOutlet weak var paysTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var donneeUtilisateur = [String:String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton.arrondissementBouton()
        
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


    @IBAction func showCondition(_ sender: UIButton) {
        
        
        var donneeOK = true
        
        if let champsMail = mailTextField.text, !champsMail.isEmpty{
            let  champsMailOk : String = mailTextField.text!
            donneeUtilisateur["mail"] = champsMailOk
        } else {
            mailTextField.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 3, revert: true)
            donneeOK = false
        }
        
        
        if let champsNom = nomTextField.text, !champsNom.isEmpty{
            let  champsNomOk : String = nomTextField.text!
            donneeUtilisateur["nom"] = champsNomOk
        } else {
            nomTextField.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 3, revert: true)
            donneeOK = false
        }
        
        
        if let champsPrenom = prenomTextField.text, !champsPrenom.isEmpty{
            let  champsPrenomOk : String = prenomTextField.text!
            donneeUtilisateur["prenom"] = champsPrenomOk
        } else {
            prenomTextField.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 3, revert: true)
            donneeOK = false
        }

        
        //-----------------------------------------------------------
        let  champsAdresse : String = adresseTextField.text!
        let  champsCP : String = codePostalTextField.text!
        let  champsVille : String = villeTextField.text!
        let  champsPays : String = paysTextField.text!
        //-----------------------------------------------------------
        donneeUtilisateur["adresse"] = champsAdresse
        donneeUtilisateur["cp"] = champsCP
        donneeUtilisateur["ville"] = champsVille
        donneeUtilisateur["pays"] = champsPays
        //-----------------------------------------------------------
        
        if donneeOK{
            performSegue(withIdentifier: "dataNewUserSegue", sender: self)
        } else {
            print("veuillez remplir tous les champs")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dataNewUserSegue" {
            let popup = segue.destination as! ConditionUseController
            popup.donneeForm = donneeUtilisateur
        }
    }
}
