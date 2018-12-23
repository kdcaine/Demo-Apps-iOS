//
//  BienvenueController.swift
//  Ezgo
//
//  Created by Puagnol John on 19/10/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit
import CoreData
import InteractiveSideMenu

class BienvenueController: UIViewController, SideMenuItemContent {
    
    @IBOutlet weak var connectionButton: UIButton!
    @IBOutlet weak var languageButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Arrondissement des boutons et ajout du shadows
        connectionButton.arrondissementBouton()
        
        
        // TODO a supprimer et auto co si il y a des données dedans. 

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
    
    @IBAction func switchLanguage(_ sender: UIButton) {
        
        let message = "Change language of this app including its content."
        let sheetCtrl = UIAlertController(title: "Choose language", message: message, preferredStyle: .actionSheet)
        
        for languageCode in Bundle.main.localizations.filter({ $0 != "Base" }) {
            let langName = Locale.current.localizedString(forLanguageCode: languageCode)
            let action = UIAlertAction(title: langName, style: .default) { _ in
                self.changeToLanguage(languageCode) // see step #2
            }
            sheetCtrl.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheetCtrl.addAction(cancelAction)
        
        sheetCtrl.popoverPresentationController?.sourceView = self.view
        sheetCtrl.popoverPresentationController?.sourceRect = self.languageButton.frame
        present(sheetCtrl, animated: true, completion: nil)
        
    }
    
    private func changeToLanguage(_ langCode: String) {
        if Bundle.main.preferredLocalizations.first != langCode {
            let message = "In order to change the language, the App must be closed and reopened by you."
            let confirmAlertCtrl = UIAlertController(title: "App restart required", message: message, preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "Close now", style: .destructive) { _ in
                UserDefaults.standard.set([langCode], forKey: "AppleLanguages")
                UserDefaults.standard.synchronize()
                exit(EXIT_SUCCESS)
                
            }
            confirmAlertCtrl.addAction(confirmAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            confirmAlertCtrl.addAction(cancelAction)
            
            present(confirmAlertCtrl, animated: true, completion: nil)
        }
    }
    
    @IBAction func showMenu(_ sender: Any) {
        showSideMenu()
    }
    
    @IBAction func coUser(_ sender: UIButton) {
        deleteAllRecords(entity: "DonneeClient")
    }
}
