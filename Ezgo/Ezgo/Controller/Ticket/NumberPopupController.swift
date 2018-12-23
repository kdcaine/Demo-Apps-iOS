//
//  NumberPopupController.swift
//  Ezgo
//
//  Created by Puagnol John on 14/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import CoreData
import UIKit

class NumberPopupController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var validButton: UIButton!
    @IBOutlet weak var zoneChoix: UIView!
    
    var articleTrouver = [ArticleEAN]()
    var ticketTrouver = [TicketGestion]()
    var positionTrouver = [Position]()
    
    var numbers = ["1"]
    var cpt = 2
    let limite = 50
    
    var choixUser: Int = 1
    
    
    // creation de la liste de quantité : 1 à 50
    func creerListePickerView(){
        
        while cpt <= limite {
            numbers.append(String(cpt))
            cpt += 1
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return numbers[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("numbre trouver")
        print(numbers[row])
        choixUser = Int(numbers[row])!
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        zoneChoix.layer.cornerRadius = 15
        creerListePickerView()
    }
    
    @IBAction func saveValue(_ sender: UIButton) {
        
        print("choix de l'utilisateur ")
        print(choixUser)
        let position = fetchPosition()
        fetchEan(index: Int(position), choix: choixUser)
        
        changementView(cible: "storyTicket")
    }
    
    func fetchPosition() -> Int16{
        
        // requete pour cibler la données.
        let requete: NSFetchRequest<Position> = Position.fetchRequest()
        
        do {
            positionTrouver = try contexte.fetch(requete)
            let donnee = positionTrouver.last?.index
            return donnee!
            
        } catch {
            // en cas d'erreur si la donnée n'existe pas
            print(error.localizedDescription)
            return 0
        }
    }
    
    func fetchEan(index: Int, choix: Int){
        
        // requete pour cibler la données.
        let requete: NSFetchRequest<ArticleEAN> = ArticleEAN.fetchRequest()
        
        do {
            articleTrouver = try contexte.fetch(requete)
            let donnee = articleTrouver[index]
            donnee.qte = Int16(choix)
            print(donnee)
            
            // Todo : verifier la liste des articles si exact et quantité exact.
            print("les articles dispo : ")
            print(articleTrouver)
            appDelegate.saveContext()
            
        } catch {
            // en cas d'erreur si la donnée n'existe pas
            print(error.localizedDescription)
        }
    }
    
    @IBAction func annuler(_ sender: UIButton) {
        changementView(cible: "storyTicket")
    }
    
    func changementView(cible : String){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Tickets", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: cible)
        self.present(nextViewController, animated:true, completion:nil)
    }
    
}

