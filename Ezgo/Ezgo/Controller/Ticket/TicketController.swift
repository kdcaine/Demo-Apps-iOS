//
//  TicketController.swift
//  Ezgo
//
//  Created by Puagnol John on 14/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit
import CoreData
import InteractiveSideMenu


class TicketController: UIViewController, UITableViewDelegate, UITableViewDataSource, SideMenuItemContent  {
    
    // variable contenant le code barre envoyé en segue depuis " ScanArticleController "
    var codeArticleScanne: String?
    
    // Initialisation des données à vide depuis le CoreData
    var infoClient = [DonneeClient]()
    var gestionTicket = [TicketGestion]()
    var listeEAN = [ArticleEAN]()
    
    
    // Initialisation de la classe ArticleDetail à vide
    var articleDetail = [ArticleDetail]()
    var articleDetailToSend = [ArticleDetail]()
    var positionSned = 0
    
    // Contiendra toutes les infos du client
    var ficheClient: String = ""
    
    //identifiant du tableau pour inserer les lignes
    let identifiantCell = "TicketCell"
    
    // Tableau à envoyer contenant toutes les JSON des tickets
    var dicoEanToSend = [String]()
    
    // Variable pour afficher ou vider le tableau
    var clearTable: Bool = false
    
    @IBOutlet weak var boutonScan: UIButton!
    @IBOutlet weak var boutonTerminer: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nbArticle: UILabel!
    
    @IBOutlet weak var gifView: UIImageView!
    @IBOutlet weak var totalTicket: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gifView.loadGif(name: "oasis")
        // Initialisation du tableaux
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        URLCache.shared.removeAllCachedResponses()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if codeArticleScanne != nil {
            // Création du ticket client
            fetchClient(codeBar: codeArticleScanne!)
        }
        else {
            print("pas de scan")
            fetchCliWithNoScan()
        }
    }
    
    // fonction pour recuperer les données du client (ces infos)
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
                        
                        // TODO à verifier si correct :
                        
                        // Le code bar :
                        print("code barre scannée : ", codeBar)
                        
                        TestArticle.getResponse(ficheClient: self.ficheClient, saveEAN: 1, articleScanner: codeBar) { (result) -> () in
    
                            // do stuff with the result
                            etatArticle = result
                            
                            print("On ajoute l'article ? : ", etatArticle)
    
                            if etatArticle {
                                self.fetchListeArticle(ajout: etatArticle, index: 0)
                            } else {
                                self.changementView(cible: "error_popup_msg")
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
        let requete: NSFetchRequest<ArticleEAN> = ArticleEAN.fetchRequest()
        
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
                
                Article.getResponse(ficheClient: self.ficheClient, articleScanner: testfinal, ajoutArticle: ajout) { (result) -> () in
                    
                    print("etat result apres getResponse Article : ", result)

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
        
        print("debut fetchTicket")
        
        let requete2: NSFetchRequest<TicketGestion> = TicketGestion.fetchRequest()
        
        do {
            gestionTicket = [TicketGestion]()
            gestionTicket = try contexte.fetch(requete2)
            
            print("contenue de gestionTicket dans f() fetchTicket : ", gestionTicket)
            
            // on vide le tableai
            articleDetail = [ArticleDetail]()
            var i = 0
            while i < self.gestionTicket.count {
                
                // Objet Article qui sera une ligne du tableau
                let cool = ArticleDetail(ean: gestionTicket[i].ean!, nom: gestionTicket[i].lib!, prixNet: gestionTicket[i].netttc, prixUttc: gestionTicket[i].puttc, qte: Int(gestionTicket[i].qte))
                
                articleDetail.append(cool)
                
                i += 1
            }
            
            // gestion pour afficher le montant total du ticket
            if self.gestionTicket.count > 0 {
                
                let dataValeur = gestionTicket.last?.ticketTotal
                
                do {
                    let decoder = JSONDecoder()
                    let finalData = try decoder.decode(DonneeValorize.self, from: dataValeur!)
                    
                    let formater = finalData.data.total.netttc
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
            //            self.tableView.scrollToBottom()
            
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    
    // Gestion des gros bouton :
    
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    
    
    
    @IBAction func terminerVente(_ sender: Any) {
        
        let infoSurTicket = TicketFini(context: contexte)
        infoSurTicket.article = dicoEanToSend.joined(separator: ",")
        
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
                        infoSurTicket.client = result
                    }
                }
            } catch {
                print(error)
            }
            
        } catch {
            infoSurTicket.client = ficheClient
            print(error.localizedDescription)
        }
        appDelegate.saveContext()
        
        self.changementView(cible: "caisseScan")
    }
    
    @IBAction func showTicket(_ sender: UIButton) {
        // TODO : ne pas oublier de réimplementer (pas vraiment utile mais bon) 
       // changementView(cible: "allTicket")
    }
    
    
    
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    
    // Gestion du tableau :
    
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.nbArticle.text = String(self.articleDetail.count)
        }
        return articleDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let article = articleDetail[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifiantCell) as? ArticleCell {
            cell.creerCell(article,position: indexPath.row)
            return cell
        }
        return UITableViewCell()
    }
    
    // definir la hauteur de chaque cellule
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let information = infoAction(at: indexPath)
        let important = importantAction(at: indexPath)
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, important, information])
    }
    
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title:"Delete") { (action, view, completion) in
            
            self.articleDetail.remove(at: indexPath.row)
            
            contexte.delete(self.listeEAN[indexPath.row])
            self.listeEAN.remove(at: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            contexte.delete(self.gestionTicket[indexPath.row])
            self.gestionTicket.remove(at: indexPath.row)
            
            do {
                try contexte.save()
            } catch {
                print(error.localizedDescription)
            }
            
            self.dicoEanToSend = [String]()
            self.fetchListeArticle(ajout: false, index: indexPath.row)
            
            self.tableView.reloadData()
            //            self.tableView.scrollToBottom()
            
            completion(true)
        }
        action.image = #imageLiteral(resourceName: "miniTrash")
        action.backgroundColor = .red
        return action
        
    }
    
    func importantAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title:"important") { (action, view, completion) in
            let positionModif = Position(context: contexte)
            positionModif.index = Int16(indexPath.row)
            appDelegate.saveContext()
            
            self.changementView(cible: "select_qte")
            
            completion(true)
        }
        action.title = "QTE"
        action.backgroundColor = hexStringToUIColor(hex: "#8fa3db")
        return action
        
    }
    
    
    func infoAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title:"Info") { (action, view, completion) in
            
            let article = self.articleDetail[indexPath.row]
            
            self.positionSned = indexPath.row
            
            
            let cool = ArticleDetail(ean: article.ean, nom: article.nom, prixNet: article.prixNet, prixUttc: article.prixUttc, qte: Int(article.qte))
            
            self.articleDetailToSend = [ArticleDetail]()
            self.articleDetailToSend.append(cool)
            
            // Todo : faire la difference entre un article alimentaire et non alimentaire.
            
            self.performSegue(withIdentifier: "segueInfoArticle1", sender: self)
            //self.performSegue(withIdentifier: "segueArticleNoFood", sender: self)
            
            completion(true)
        }
        action.image = #imageLiteral(resourceName: "info")
        action.backgroundColor = .lightGray
        return action
        
    }
    
    
    // A enlever en com apres le 1er test car utile pour afficher le detail
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueInfoArticle1" {
            let vc = segue.destination as! InfoArticleController
            vc.articleInformation = self.articleDetailToSend
            vc.position = self.positionSned
        }
        
        if segue.identifier == "segueArticleNoFood" {
            let vc = segue.destination as! InfoArticleNoFoodController
            vc.articleInformation = self.articleDetailToSend
        }

    }
    
    
    ////////////////////////////////////////////////////////////////////////
    
    // bouton de redirection :
    
    @IBAction func showMenu(_ sender: Any) {
        print("affiche toi !!!! ")
        showSideMenu()
    }
    
    @IBAction func goToListe(_ sender: UIButton) {
        changementView(cible: "all_liste_course")
    }
    
    func changementView(cible : String){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Tickets", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: cible)
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    
    // Fonction générique ( outils ) :
    
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    
    
    // Fonction de gestion de couleur
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // Supprimer donnée dans le Core Data :
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


