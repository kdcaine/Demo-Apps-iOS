//
//  ListeCommandeController.swift
//  Ezgo
//
//  Created by Puagnol John on 15/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit
import CoreData

class ListeCommandeController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalTicket: UILabel!
    @IBOutlet weak var labelOrder: UILabel!
    @IBOutlet weak var numeroCommande: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var codeEAN: String?
    var prixFinal: Double = 0.0
    
    // Initialisation des données à vide depuis le CoreData
    var infoClient = [DonneeClient]()
     var gestionCommande = [ListeCommande]()
    var listeEAN = [ArticleCommandeEAN]()
    
    //
    var mesArticlesList = [ArticleDetail]()
    
    // Contiendra toutes les infos du client
    var ficheClient: String = ""
    
    //identifiant du tableau pour inserer les lignes
    let identifiantCell = "listeArticleCommand"
    
    // Tableau à envoyer contenant toutes les JSON des tickets
    var dicoEanToSend = [String]()
    
    // Variable pour afficher ou vider le tableau
    var clearTable: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if codeEAN != nil {
            fetchClient(codeBar: codeEAN!)
        }
        else {
            print("pas de scan")
            fetchCliWithNoScan()
        }
    }
    
    func fetchClient(codeBar: String) {
        
        // requete pour cibler la données.
        let requete: NSFetchRequest<DonneeClient> = DonneeClient.fetchRequest()
        
        do {
            // réponse contenant les données du client :
            infoClient = try contexte.fetch(requete)
            guard let donnee = infoClient.last?.client else {
                print("No data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(CompteUser.self, from: donnee)
                
                if  let idClientFind = result.data.idcli{
                    
                    RefreshUser.getResponse(idco: idClientFind) { (result) -> () in
                        
                        self.ficheClient = result
                        
                        var etatArticle: Bool = false
                        
                        TestArticle.getResponse(ficheClient: self.ficheClient, saveEAN: 0,  articleScanner: codeBar) { (result) -> () in
                            
                            print("resultat : ", result)
                            etatArticle = result
                            
                            self.fetchListeArticle(ajout: etatArticle, index: 0)
                        }
                    }
                }
            } catch {
                print(error)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func fetchCliWithNoScan() {
        
        // requete pour cibler la données.
        let requete: NSFetchRequest<DonneeClient> = DonneeClient.fetchRequest()
        
        do {
            // réponse contenant les données du client :
            infoClient = try contexte.fetch(requete)

            guard let donnee = infoClient.last?.client else {
                print("No data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(CompteUser.self, from: donnee)
                
                if  let idClientFind = result.data.idcli{
                    
                    RefreshUser.getResponse(idco: idClientFind) { (result) -> () in
                        self.ficheClient = result
                        self.fetchListeArticle(ajout: false, index: 0)
                    }
                }
            } catch {
                print(error)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Generation de la liste d'article de ticket
    func fetchListeArticle(ajout: Bool, index: Int) {
        
        // requete pour cibler la données.
        let requete: NSFetchRequest<ArticleCommandeEAN> = ArticleCommandeEAN.fetchRequest()
        
        do {
            listeEAN = try contexte.fetch(requete)
            
            if listeEAN.isEmpty {
                print("liste vide")
            } else {
                
                // nettoyage de dictionnaire d'ean pour avoir une base propre.
                dicoEanToSend = [String]()
                
                var i = 0
                while i < listeEAN.count {
                    
                    let debut = "{"
                    let cle1 = "\"ean\""
                    let sep1 = ":\""
                    let cle2 = "\",\"qte\""
                    let sep2 = ":"
                    let fin = "}"
                    
                    let eanFinal = debut + cle1 + sep1 + listeEAN[i].ean! + cle2 + sep2 + String(listeEAN[i].qte) + fin
                    
                    dicoEanToSend.append(eanFinal)
                    
                    i += 1
                }
                
                let testfinal = dicoEanToSend.joined(separator: ",")
                
                // On envoye un valorize
                
                ArticleOrder.getResponse(ficheClient: self.ficheClient, articleScanner: testfinal, ajoutArticle: ajout) { (result) -> () in

                    if result {
                        self.fetchTicket()
                    }
                }
            }
        } catch {
            // en cas d'erreur si la donnée n'existe pas
            print(error.localizedDescription)
        }
    }
    
    // recupere les donnée du tickets pour les afficher dans le tableau
    func fetchTicket() {
        
        let requete2: NSFetchRequest<ListeCommande> = ListeCommande.fetchRequest()
        
        do {
            gestionCommande = [ListeCommande]()
            gestionCommande = try contexte.fetch(requete2)
            
            // on vide le tableai
            mesArticlesList = [ArticleDetail]()
            var i = 0
            while i < self.gestionCommande.count {
                
                // Objet Article qui sera une ligne du tableau
                let cool = ArticleDetail(ean: gestionCommande[i].ean!, nom: gestionCommande[i].lib!, prixNet: gestionCommande[i].netttc, prixUttc: gestionCommande[i].puttc, qte: Int(gestionCommande[i].qte))
                
                mesArticlesList.append(cool)
                
                i += 1
            }
            
            // gestion pour afficher le montant total du ticket
            if self.gestionCommande.count > 0 {
                
                let dataValeur = gestionCommande.last?.ticketTotal
                do {
                    let decoder = JSONDecoder()
                    let finalData = try decoder.decode(DonneeValorize.self, from: dataValeur!)
                    
                    let formater = finalData.data.total.netttc
                    self.prixFinal = formater
                    let goodFormat = String(format: "%.2f", formater)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.totalTicket.text = goodFormat
                    }
                    
                    
                }catch {
                    print("error")
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.tableView.reloadData()
                
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    ////////////////////////////////////////////////////////////////////////
    ////////                Gestion du TableView                ////////////
    ////////////////////////////////////////////////////////////////////////
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mesArticlesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let article = mesArticlesList[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifiantCell) as? ArticleCommandeCell {
            cell.creerCell(article,position: indexPath.row)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title:"Delete") { (action, view, completion) in
            
            self.mesArticlesList.remove(at: indexPath.row)
            
            contexte.delete(self.listeEAN[indexPath.row])
            self.listeEAN.remove(at: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            contexte.delete(self.gestionCommande[indexPath.row])
            self.gestionCommande.remove(at: indexPath.row)
            
            do {
                try contexte.save()
            } catch {
                print(error.localizedDescription)
            }
            
            self.dicoEanToSend = [String]()
            self.fetchListeArticle(ajout: false, index: indexPath.row)
            
            self.tableView.reloadData()
            
            self.tableView.reloadData()
            completion(true)
        }
        action.image = #imageLiteral(resourceName: "miniTrash")
        action.backgroundColor = .red
        return action
        
    }
    
    @IBAction func saveCommande(_ sender: UIButton) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.spinner.isHidden = false
        }
        
        let maListeFinalCommande = dicoEanToSend.joined(separator: ",")
        
        let requete: NSFetchRequest<DonneeClient> = DonneeClient.fetchRequest()
        
        do {
            // réponse contenant les données du client :
            infoClient = try contexte.fetch(requete)
            
            guard let donnee = infoClient.last?.client else {
                print("No data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(CompteUser.self, from: donnee)
                
                if  let idClientFind = result.data.idcli{
                    
                    RefreshUser.getResponse(idco: idClientFind) { (result) -> () in
                        
                        self.ficheClient = result
                        Save.getResponse(ficheClient: result, articleScanner: maListeFinalCommande) { (result) -> () in
                                                        
                            let date = Date()
                            let formatter = DateFormatter()
                            
                            formatter.dateFormat = "dd/MM/yyyy"
                            
                            let dateFinal = formatter.string(from: date)
                            
                            let commandeActuelle = MesCommandesSave(context: contexte)
                            commandeActuelle.numero = result
                            commandeActuelle.date = dateFinal
                            commandeActuelle.montant = self.prixFinal
                            appDelegate.saveContext()
                            
                            // on vide la liste ensuite :
                            self.deleteAllRecords(entity: "ListeCommande")
                            self.deleteAllRecords(entity: "ArticleCommandeEAN")
                            self.mesArticlesList = [ArticleDetail]()
                            
                            // On met à jour la table
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                self.tableView.reloadData()
                                self.spinner.stopAnimating()
                                self.labelOrder.isHidden = false
                                self.numeroCommande.isHidden = false
                                self.numeroCommande.text = result
                                self.totalTicket.text = "0.00 €"
                            }
                           
                        }
                        
                       
                    }
                }
            } catch {
                print(error)
            }
        
        } catch {
            print(error.localizedDescription)
        }
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
}
