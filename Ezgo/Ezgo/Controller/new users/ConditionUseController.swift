//
//  ConditionUseController.swift
//  Ezgo
//
//  Created by Puagnol John on 19/10/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit

class ConditionUseController: UIViewController {

    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var viewConditions: UIView!
    
    
    // Donnée du formulaire reçu par segue :
    var donneeForm = [String:Any]()
    
    
    // Etat d'acception des conditons :
    
    var adpStatus: Bool = false
    var gtuStatus: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yesButton.arrondissementBouton()
        noButton.arrondissementBouton()
        
        let name = Notification.Name(rawValue: "ConnexionOK")     // Nom de la notification
        NotificationCenter.default.addObserver(self, selector: #selector(pageLoaded) , name: name, object: nil)
    }
    

    @IBAction func accepter(_ sender: UIButton) {
        if gtuStatus {
            print("l'utilisateur peut créer son compte !!!! ")
            donneeForm["gtu"] = 1
            if adpStatus {
                donneeForm["adp"] = 1
            } else {
                donneeForm["adp"] = 0
            }
            NewUser.getResponse(form: donneeForm)
        }
    }
    
    @objc func pageLoaded(){
        
        // ajout 1 seconde de latence
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.changementView(cible: "storyClient")
        }
        
    }
    
    
    @IBAction func refuser(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func acceptDonnee(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (success) in
            sender.isSelected = !sender.isSelected
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                sender.transform = .identity
                self.adpStatus = sender.isSelected
            }, completion: nil)
        }
    }
    
    @IBAction func acceptCondition(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (success) in
            sender.isSelected = !sender.isSelected
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                sender.transform = .identity
                self.gtuStatus = sender.isSelected
            }, completion: nil)
        }
    }
    
    func changementView(cible : String){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Client", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: cible)
        self.present(nextViewController, animated:true, completion:nil)
    }
    

}
