//
//  AllCatalogueController.swift
//  Ezgo
//
//  Created by Puagnol John on 13/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit
import SDWebImage
import InteractiveSideMenu

class AllCatalogueController: UIViewController, SideMenuItemContent {

    @IBOutlet weak var catalogueActuel: UIImageView!
    @IBOutlet weak var nextCatalogue: UIImageView!
    
    var listeCatalogue : [String] = []
    var catalogueAssocie = ""
    var thePosition = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ajout des event sur le clic des catalogue.
        let singleTap1 = UITapGestureRecognizer(target: self, action: #selector(AllCatalogueController.tapDetectedCatalogueActuel))
        catalogueActuel.isUserInteractionEnabled = true
        catalogueActuel.addGestureRecognizer(singleTap1)
        
        let singleTap2 = UITapGestureRecognizer(target: self, action: #selector(AllCatalogueController.tapDetectedFuturCatalogue))
        nextCatalogue.isUserInteractionEnabled = true
        nextCatalogue.addGestureRecognizer(singleTap2)
        
        // on recuper les données depuis le service web
        
        let ip = ""
        let ipServ = ip.getIp()
                
        if let url = URL(string: "http://" + ipServ + ":8899/assets/list_catalogs.json") {
            
            do {
                let contents = try String(contentsOf: url)
                catalogueAssocie = contents
                
                let dico = contents.convertToTabDictionary()
                
                var i = 0
                for catalogue in dico! {
                    
                    let urlImage = catalogue["urlImg"] as? String
                    
                    listeCatalogue.append(urlImage!)
                    i += 1
                }
                
                
                let urlI1 = URL(string: listeCatalogue[0])
                //catalogueActuel.load(url: urlI1!)
                catalogueActuel.sd_setImage(with: urlI1, placeholderImage: UIImage(named: "catalogue_actuel"))

                let urlI2 = URL(string: listeCatalogue[1])
                //nextCatalogue.load(url: urlI2!)
                nextCatalogue.sd_setImage(with: urlI2, placeholderImage: UIImage(named: "catalogue_suivant"))
                
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func tapDetectedCatalogueActuel() {
        print("Imageview Clicked v1")
        thePosition = 0
        performSegue(withIdentifier: "segueCategorie", sender: self)
    }
    
    @objc func tapDetectedFuturCatalogue() {
        print("Imageview Clicked v2")
        thePosition = 1
        performSegue(withIdentifier: "segueCategorie", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCategorie" {
            let vc = segue.destination as! CategorieController
            vc.monCatalogue = self.catalogueAssocie
            vc.position = self.thePosition
        }
    }
    
    @IBAction func showMenu(_ sender: Any) {
        showSideMenu()
    }
}
