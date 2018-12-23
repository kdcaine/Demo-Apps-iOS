//
//  SettingsController.swift
//  Ezgo
//
//  Created by Puagnol John on 05/12/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit
import CoreData
import InteractiveSideMenu

class SettingsController: MenuViewController, UIPickerViewDelegate, UIPickerViewDataSource, SideMenuItemContent {

    

    @IBOutlet weak var adresseServeur: UITextField!
    @IBOutlet weak var saveAdresse: UIButton!
    @IBOutlet weak var success: UIImageView!
    @IBOutlet weak var reset: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    
    var infoServeur = [Serveur]()
    var listeTotalMagasin = [Magasin]()
    var oldIpServ = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
         hideKeyboard()
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
        let requete: NSFetchRequest<Serveur> = Serveur.fetchRequest()
        
        do {
            infoServeur = try contexte.fetch(requete)
            
            if let oldAddr = infoServeur.last?.adresse{
                adresseServeur.text = oldAddr
                oldIpServ = oldAddr
            } else {
                adresseServeur.text = "172.20.44.100"
                oldIpServ = "172.20.44.100"
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        RecupMag.getMag() { (result) -> () in
            
            self.listeTotalMagasin = result
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.picker.reloadAllComponents()
            }
        }
    }
    

    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.listeTotalMagasin.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return self.listeTotalMagasin[row].lib
    }
    
    // TODO : finir la fonction pour la selection du magasin.
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // methode for recup row selected.
        
    }
    

    @IBAction func saveMyAdresse(_ sender: UIButton) {
        
        if let monTexte = adresseServeur.text, !monTexte.isEmpty{
            
            deleteAllRecords(entity: "Serveur")
            
            let monServeur = Serveur(context: contexte)
            monServeur.adresse = monTexte
            appDelegate.saveContext()
            
            success.isHidden = false
            saveAdresse.isHidden = true
        }
    }
    
    func getInitial(string: String) -> UIViewController {
        let storyboard = UIStoryboard(name: string, bundle: nil)
        return storyboard.instantiateInitialViewController() ?? UIViewController()
    }
    
    @IBAction func resetSettings(_ sender: UIButton) {
        
         adresseServeur.text = oldIpServ
    }
    
    func deleteAllRecords(entity: String) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    @IBAction func showMenu(_ sender: Any) {
        showSideMenu()
    }
    
}
