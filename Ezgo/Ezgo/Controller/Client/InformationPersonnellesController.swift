//
//  InformationPersonnellesController.swift
//  Ezgo
//
//  Created by Puagnol John on 13/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit
import CoreData

class InformationPersonnellesController: UIViewController {

    @IBOutlet weak var nom: UILabel!
    @IBOutlet weak var prenom: UILabel!
    @IBOutlet weak var adresse: UILabel!
    @IBOutlet weak var cp: UILabel!
    @IBOutlet weak var ville: UILabel!
    @IBOutlet weak var pays: UILabel!
    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var mail: UILabel!
    
    @IBOutlet weak var boutonModif: UIButton!
    
    var infoClient = [DonneeClient]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        boutonModif.arrondissementBouton()
        fetchClient()
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
                
                // on recupere le nom client :
                if let nomClientTrouver = contenuDico.nom{
                    nom.text = nomClientTrouver
                }
                
                // on recupere le prenom client :
                if let prenomClientTrouver = contenuDico.prenom{
                    prenom.text = prenomClientTrouver
                }
                // on recupere l'adresse client :
                if let prenomClientTrouver = contenuDico.adr1{
                    adresse.text = prenomClientTrouver
                }

                // on recupere le cp client :
                if let cpClientTrouver = contenuDico.cp{
                    cp.text = cpClientTrouver
                }
                // on recupere la ville client :
                if let villeClientTrouver = contenuDico.ville{
                    ville.text = villeClientTrouver
                }
                // on recupere le pays client :
                if let villeClientTrouver = contenuDico.pays{
                    pays.text = villeClientTrouver
                }
                // on recupere le numero de téléphone du client :
                if let telTrouver = contenuDico.tel{
                    tel.text = telTrouver
                }
                // on recupere le mail client :
                if let mailClientTrouver = contenuDico.email{
                    mail.text = mailClientTrouver
                }

                
            } catch {
                print(error)
            }
           
        } catch {
            // en cas d'erreur si la donnée n'existe pas
            print(error.localizedDescription)
        }
    }
}
