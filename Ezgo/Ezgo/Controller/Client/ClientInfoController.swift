//
//  ClientInfoController.swift
//  Ezgo
//
//  Created by Puagnol John on 22/10/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import InteractiveSideMenu

class ClientInfoController: UIViewController, UIScrollViewDelegate, SideMenuItemContent {
    
    @IBOutlet weak var zoneCarte: UIView!
    
    @IBOutlet weak var codeClient: UILabel!
    @IBOutlet weak var codeBarre: UIImageView!
    @IBOutlet weak var nomComplet: UILabel!
    
    
    @IBOutlet weak var labelCagnotte: UILabel!
    @IBOutlet weak var labelPoints: UILabel!
    @IBOutlet weak var soldePoints: UILabel!
    @IBOutlet weak var soldeCagnotte: UILabel!
    
    @IBOutlet weak var loadSpinner: UIActivityIndicatorView!
    @IBOutlet weak var aucuneOffre: UILabel!
    @IBOutlet weak var bigZone1: UIView!
    @IBOutlet weak var dimension1: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    @IBOutlet weak var loadProbe: UIActivityIndicatorView!
    @IBOutlet weak var aucuneProposition: UILabel!
    @IBOutlet weak var bigZone2: UIView!
    @IBOutlet weak var dimension2: UIView!
    @IBOutlet weak var scrollView2: UIScrollView!
    
    var tagValue = 100
    var viewTagValue = 10
    
    var infoClient = [DonneeClient]()
    var idClientFind = ""
    
    var listeSpecial : [OffersChoice] = []
    
    // Pour demo
    var listeOffreMoment : [[String:Any]] = []
    
    var probeList : [ListSondage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        zoneCarte.arrondissementZone(addShadow: true)
        
        bigZone1.arrondissementZone(addShadow: true)
        dimension1.arrondissementZone(addShadow: false)
        
        bigZone2.arrondissementZone(addShadow: true)
        dimension2.arrondissementZone(addShadow: false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("affiche moi")
        fetchClient()
        getPromo()
        getSondage()
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
                
                var nomDuClient = ""
                
                // on recupere l'id client :
                if let idClient = result.data.idcli{
                    codeClient.text = idClient
                    codeBarre.generateBarcode(string: idClient)
                    self.idClientFind = idClient
                }
                
                let contenuDico = result.data.head
                
                // on recupere le nom client :
                if let nomClientTrouver = contenuDico.nom{
                    nomDuClient += nomClientTrouver
                }
                // on recupere le prenom client :
                if let prenomClientTrouver = contenuDico.prenom{
                    nomDuClient += " " + prenomClientTrouver
                }
                
                let contenuCompteurs = result.data.compteurs
                
                for cptStat in contenuCompteurs {

                    let valcpt = cptStat.s0

                    let nameCompteur = cptStat.lib
                    if nameCompteur == "PASSAGE" {
                        self.labelPoints.text = nameCompteur
                        self.soldePoints.text = "\(valcpt)"
                    }
                    else {
                        self.labelCagnotte.text = nameCompteur
                        var myMonnaie = Double(valcpt)
                        myMonnaie = myMonnaie / 100
                        self.soldeCagnotte.text = String(format: "%.2f", myMonnaie) + " €"
                    }
                }
                nomComplet.text = nomDuClient
                zoneCarte.layer.cornerRadius = 10
                
            } catch {
                print(error)
            }
            
        } catch {
            // en cas d'erreur si la donnée n'existe pas
            print(error.localizedDescription)
        }
    }
    
    func getPromo() {
        let ip = ""
        let ipServ = ip.getIp()
        
        let urlTest = URL(string: "http://" + ipServ + ":8484/orkecom/api/client/offers/chosen")
        
        var request : URLRequest
        request = createReponseRequestIdcli(idcli: idClientFind, url: urlTest!)
        
        let session = URLSession(configuration: .default)
        
        
        let task = session.dataTask(with: request) { data, response, error in
            
            // ensure there is no error for this HTTP response
            guard error == nil else {
                print ("error: \(error!)")
                return
            }
            
            // ensure there is data returned from this HTTP response
            guard let content = data else {
                print("No data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(ListeOffreChoisi.self, from: content)
                
                for offreDispo in result.data.offers {
                    self.listeSpecial.append(offreDispo)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if self.listeSpecial.count > 0 {
                        self.bigZone1.isHidden = false
                        self.scrollView.contentSize.width = self.scrollView.frame.width * CGFloat(self.listeSpecial.count)
                        self.creerRemise(list: self.listeSpecial, cibleScrollView: self.scrollView)
                    } else {
                        self.aucuneOffre.isHidden = false
                    }
                    
                    self.loadSpinner.stopAnimating()
                }
                
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    
    func getSondage(){
        
        let ip = ""
        let ipServ = ip.getIp()
                
        if let url = URL(string: "http://" + ipServ + ":8899/assets/probe.json") {
            do {
                let contents = try Data(contentsOf: url)

                let decoder = JSONDecoder()
                let result = try decoder.decode(SondageArticle.self, from: contents)
                
                let probeListAll = result.list
                
                for probe in probeListAll{
                    probeList.append(probe)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if self.probeList.count > 0 {
                        self.bigZone2.isHidden = false
                        self.scrollView2.contentSize.width = self.scrollView2.frame.width * CGFloat(self.probeList.count)
                        self.creerPromotion(list: self.probeList, cibleScrollView: self.scrollView2)
                    } else {
                        self.aucuneProposition.isHidden = false
                    }
                    
                    self.loadProbe.stopAnimating()
                }
            } catch {
                print(error)
            }
        }
    }
    
    
    
    
    // recupere les offres disponibles sur orkidée :
    func creerRemise(list : [OffersChoice], cibleScrollView : UIScrollView ){
        
        var i = 0
        for data in list {
            
            let view = CustomView(frame: CGRect(x: 15 + ((self.view.frame.width - 30) * CGFloat(i)), y: 20, width: self.view.frame.width - 60, height: 120 ))
            
            // gestion de date limite de la promo
            let frameRemaining = CGRect(x: view.center.x , y: 0, width: 250, height: 20 )
            
            let labelRemaining = UILabel(frame: frameRemaining)
            
            let formatter: DateFormatter = {
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = Calendar.current.timeZone
                dateFormatter.locale = Calendar.current.locale
                dateFormatter.dateFormat = "dd MMMM yyyy"
                return dateFormatter
            }()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let date = dateFormatter.date(from: data.dateFin!)
            
            labelRemaining.text = "jusqu'au " + formatter.string(from: date!)
            labelRemaining.textAlignment = .center
            labelRemaining.textColor = UIColor.gray
            labelRemaining.center.x = view.center.x
            cibleScrollView.addSubview(labelRemaining)
            
            // ajout de l'image
            var myImgPromo = ""
            if let imgPromo = data.img , !imgPromo.isEmpty{
                myImgPromo = imgPromo
            } else {
                myImgPromo = "promo"
            }
            
            view.imageView.loadGif(name: myImgPromo)
            view.tag = i + viewTagValue
            cibleScrollView.addSubview(view)
            
            // Nom de la promo
            let frameName = CGRect(x: view.center.x , y: view.frame.maxY + 5, width: view.frame.width - 20, height: 40 )
            
            let label = UILabel(frame: frameName)
            label.text = data.com
            label.textAlignment = .center
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
            label.font = UIFont.systemFont(ofSize: 15)
            label.textColor = UIColor.gray
            label.center.x = view.center.x
            cibleScrollView.addSubview(label)
            
            // Taux de reduction de la promo
            let frameTaux = CGRect(x: view.center.x , y: frameName.maxY + 1, width: 250, height: 14 )
            
            let labelTaux = UILabel(frame: frameTaux)
            labelTaux.text = data.lib
            labelTaux.textAlignment = .center
            labelTaux.font = UIFont.boldSystemFont(ofSize: 20.0)
            labelTaux.textColor = hexStringToUIColor(hex: "#ED7905")
            labelTaux.center.x = view.center.x
            cibleScrollView.addSubview(labelTaux)
            
            // Total utilisation de la promo
            let frameUse = CGRect(x: view.center.x , y: frameTaux.maxY + 5, width: 250, height: 14 )
            
            let labelUse = UILabel(frame: frameUse)
            labelUse.text = "Offre utilisée " + String(data.uses) + "x sur " + String(data.max)
            labelUse.textAlignment = .center
            labelUse.textColor = UIColor.lightGray
            labelUse.center.x = view.center.x
            cibleScrollView.addSubview(labelUse)
            
            
            i += 1
        }
    }
    
    
   
    
    
    
    
    func creerPromotion(list : [ListSondage], cibleScrollView : UIScrollView ){
        
        var i = 0
        for data in list {
            
            let view = CustomView(frame: CGRect(x: 15 + ((self.view.frame.width - 30) * CGFloat(i)), y: 20, width: self.view.frame.width - 60, height: 120 ))
            
            // gestion de date limite de la promo
            let frameRemaining = CGRect(x: view.center.x , y: 0, width: 150, height: 20 )
            
            let labelRemaining = UILabel(frame: frameRemaining)
            labelRemaining.text = data.remaining
            labelRemaining.textAlignment = .center
            labelRemaining.textColor = UIColor.gray
            labelRemaining.center.x = view.center.x
            cibleScrollView.addSubview(labelRemaining)
            
            // ajout de l'image
            let urlImage = data.urlImg
            let urlIB = URL(string: urlImage!)
            view.imageView.load(url: urlIB!)
            view.tag = i + viewTagValue
            cibleScrollView.addSubview(view)
            
            // Nom de la promo
            let frameName = CGRect(x: view.center.x , y: view.frame.maxY + 5, width: 250, height: 20 )
            
            let label = UILabel(frame: frameName)
            label.text = data.description
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 20.0)
            label.textColor = UIColor.gray
            label.center.x = view.center.x
            cibleScrollView.addSubview(label)
            
            // Taux de reduction de la promo
            let frameTaux = CGRect(x: view.center.x , y: frameName.maxY + 10, width: 250, height: 14 )
            
            let labelTaux = UILabel(frame: frameTaux)
            labelTaux.text = data.reduction
            labelTaux.textAlignment = .center
            labelTaux.font = UIFont.boldSystemFont(ofSize: 20.0)
            labelTaux.textColor = hexStringToUIColor(hex: "#ED7905")
            labelTaux.center.x = view.center.x
            cibleScrollView.addSubview(labelTaux)
            
            
            // Ajout du bouton :
            
            let frameBouton = CGRect(x: view.center.x , y: frameTaux.maxY + 10, width: 250, height: 40 )
            
            let boutton = UIButton(frame: frameBouton)
            boutton.setTitle("CHOISIR L'OFFRE", for: .normal)
            boutton.backgroundColor = hexStringToUIColor(hex: "#ED7905")
            boutton.center.x = view.center.x
            //            boutton.addTarget(self, action: #selector(imageButtonTapped(_:)), for: .touchUpInside)
            boutton.arrondissementBouton()
            cibleScrollView.addSubview(boutton)
            
            
            // Total utilisation de la promo
            let frameUse = CGRect(x: view.center.x , y: frameBouton.maxY + 5, width: 250, height: 14 )
            
            let labelUse = UILabel(frame: frameUse)
            labelUse.text = data.count
            labelUse.textAlignment = .center
            labelUse.textColor = UIColor.lightGray
            labelUse.center.x = view.center.x
            cibleScrollView.addSubview(labelUse)
            
            i += 1
        }
    }
    
    
    
    
    
    
    
    
    
    
    func createReponseRequestIdcli(idcli : String, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // prepare json data
        let json: [String: Any] = ["idcli": idcli]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        
        return request
    }
    
    
    func hexStringToUIColor(hex:String) -> UIColor {
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
    
    @IBAction func showMenu(_ sender: Any) {
        showSideMenu()
    }
}

