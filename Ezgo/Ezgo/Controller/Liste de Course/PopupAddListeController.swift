//
//  PopupAddListeController.swift
//  Ezgo
//
//  Created by Puagnol John on 15/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit
import CoreData

class PopupAddListeController: UIViewController {

    @IBOutlet weak var maZone: UIView!
    @IBOutlet weak var titre: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        maZone.arrondissementZone(addShadow: true)
        
        self.hideKeyboard()
    }
    
    @IBAction func dismissPopup(_ sender: UIButton) {
        ajoutDonne()
        changementView(cible: "all_liste_course")
    }
    @IBAction func cancelPopup(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func ajoutDonne(){
        
        // test si le champs n'est pas vide pr carte client
        if let text1 = titre.text, !text1.isEmpty{
            
            let cMonChoix = ListeCourse(context: contexte)
            cMonChoix.nom = text1
            
            appDelegate.saveContext()
        }
        else {
            print("champs vide")
        }
    }
    
    func changementView(cible : String){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Tickets", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: cible)
        self.present(nextViewController, animated:true, completion:nil)
    }
}

