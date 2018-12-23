//
//  ResumeCommandController.swift
//  Ezgo
//
//  Created by Puagnol John on 13/12/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit
import CoreData
import InteractiveSideMenu

class ResumeCommandController: UIViewController, UITableViewDelegate, UITableViewDataSource, SideMenuItemContent {
    
    @IBOutlet weak var tableView: UITableView!
    
    var listeDeCommande = [MesCommandesSave]()
    var mesCommandes = [ListeOrder]()

    let identifiantCell = "CellCommandeNumber"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        fetchAllListeCommande()

    }
    
    func fetchAllListeCommande() {
        
        // requete pour cibler la données.
        let requete: NSFetchRequest<MesCommandesSave> = MesCommandesSave.fetchRequest()
        
        do {
            // réponse contenant les données du client :
            listeDeCommande = try contexte.fetch(requete)
            mesCommandes =  [ListeOrder]()
            
            for list in listeDeCommande{
                let codeCommande = list.numero
                let dateCommande = list.date
                let prixCommande = list.montant
                
                let myOrderFind = ListeOrder(code: codeCommande!, date: dateCommande!, prixNet: prixCommande)
                mesCommandes.append(myOrderFind)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.tableView.reloadData()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mesCommandes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let maListe =  mesCommandes[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifiantCell) as?  CommandeCell {
            cell.creerCell(maListe)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @IBAction func showMenu(_ sender: Any) {
        showSideMenu()
    }
}
