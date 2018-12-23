//
//  PromotionsController.swift
//  Ezgo
//
//  Created by Puagnol John on 13/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit
import CoreData
import InteractiveSideMenu

struct scrollViewDataStruct {
    let title : String?
    let image : UIImage?
}

class PromotionsController: UIViewController, UIScrollViewDelegate, SideMenuItemContent {
    
    var infoClient = [DonneeClient]()
    
    @IBOutlet weak var bigZone1: UIView!
    @IBOutlet weak var bigZone2: UIView!
    @IBOutlet weak var bigZone3: UIView!
    @IBOutlet weak var dimension1: UIView!
    @IBOutlet weak var dimension2: UIView!
    @IBOutlet weak var dimension3: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollOffreDay: UIScrollView!
    @IBOutlet weak var scrollOffreMoment: UIScrollView!
    
    @IBOutlet weak var spinner1: UIActivityIndicatorView!
    @IBOutlet weak var msgZone1: UILabel!
    
    var scrollViewData = [scrollViewDataStruct]()
    
    var tagValue = 100
    var viewTagValue = 10
    
    
    var listeOffreDay : [[String:Any]] = []
    var listeOffreMoment : [[String:Any]] = []
    
    var listeSpecial : [Offers] = []
    
    var idClientFind = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchClient()
        
        getPromo()
        
        scrollView.delegate = self
        scrollOffreDay.delegate = self
        scrollOffreMoment.delegate = self
        
        
        bigZone1.arrondissementZone(addShadow: true)
        bigZone2.arrondissementZone(addShadow: true)
        bigZone3.arrondissementZone(addShadow: true)
        
        dimension1.arrondissementZone(addShadow: false)
        dimension2.arrondissementZone(addShadow: false)
        dimension3.arrondissementZone(addShadow: false)
        
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        let ip = ""
        let ipServ = ip.getIp()
        
        if let url = URL(string: "http://" + ipServ + ":8899/assets/offers.json") {
            do {
                let contents = try String(contentsOf: url)
                
                let dico = contents.convertToTabDictionary()
                
                let offresDayAll = dico?[1]["list"] as! [[String:Any]]
                
                for offreDays in offresDayAll {
                    listeOffreDay.append(offreDays)
                }
                
                let offreMomentAll = dico?[2]["list"]as! [[String:Any]]
                
                for offreMoment in offreMomentAll {
                    listeOffreMoment.append(offreMoment)
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
        
        showPromoPerso()
        
        
        scrollOffreDay.contentSize.width = self.scrollOffreDay.frame.width * CGFloat(listeOffreDay.count)
        scrollOffreMoment.contentSize.width = self.scrollOffreMoment.frame.width * CGFloat(listeOffreMoment.count)
        
        
        creerPromotion(list: listeOffreDay, cibleScrollView: scrollOffreDay)
        creerPromotion(list: listeOffreMoment, cibleScrollView: scrollOffreMoment)
        
    }
    
    func showPromoPerso(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            
            if self.listeSpecial.count > 0 {
                self.scrollView.contentSize.width = self.scrollView.frame.width * CGFloat(self.listeSpecial.count)
                self.creerRemise(list: self.listeSpecial, cibleScrollView: self.scrollView)
            } else {
                self.msgZone1.isHidden = false
            }
            self.spinner1.stopAnimating()
            
        }
    }
    
    // recupere les offres disponibles sur orkidée :
    func creerRemise(list : [Offers], cibleScrollView : UIScrollView ){
        
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
            if let imgPromo = data.img , !imgPromo.isEmpty{
                let urlIB = URL(string: imgPromo)
                view.imageView.load(url: urlIB!)
            } else {
                let myImgPromo = "promo"
                view.imageView.loadGif(name: myImgPromo)
            }
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
            let frameTaux = CGRect(x: view.center.x , y: frameName.maxY + 10, width: 250, height: 14 )
            
            let labelTaux = UILabel(frame: frameTaux)
            labelTaux.text = data.lib
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
            boutton.tag = data.id
            boutton.addTarget(self, action: #selector(imageButtonTapped(_:)), for: .touchUpInside)
            boutton.arrondissementBouton()
            cibleScrollView.addSubview(boutton)
            
            
            // Total utilisation de la promo
            let frameUse = CGRect(x: view.center.x , y: frameBouton.maxY + 15, width: 250, height: 14 )
            
            let labelUse = UILabel(frame: frameUse)
            labelUse.text = "Offre utilisable " + String(data.max) + "x"
            labelUse.textAlignment = .center
            labelUse.textColor = UIColor.lightGray
            labelUse.center.x = view.center.x
            cibleScrollView.addSubview(labelUse)
            
            i += 1
        }
    }
    
    
    
    
    
    // recupere le fichier json fait par arnold
    func creerPromotion(list : [[String:Any]], cibleScrollView : UIScrollView ){
        
        var i = 0
        for data in list {
            
            let view = CustomView(frame: CGRect(x: 15 + ((self.view.frame.width - 30) * CGFloat(i)), y: 20, width: self.view.frame.width - 60, height: 120 ))
            
            // gestion de date limite de la promo
            let frameRemaining = CGRect(x: view.center.x , y: 0, width: 150, height: 20 )
            
            let labelRemaining = UILabel(frame: frameRemaining)
            labelRemaining.text = data["remaining"] as? String
            labelRemaining.textAlignment = .center
            labelRemaining.textColor = UIColor.gray
            labelRemaining.center.x = view.center.x
            cibleScrollView.addSubview(labelRemaining)
            
            // ajout de l'image
            let urlImage = data["urlImg"] as? String
            let urlIB = URL(string: urlImage!)
            view.imageView.load(url: urlIB!)
            view.tag = i + viewTagValue
            cibleScrollView.addSubview(view)
            
            // Nom de la promo
            let frameName = CGRect(x: view.center.x , y: view.frame.maxY + 5, width: 250, height: 20 )
            
            let label = UILabel(frame: frameName)
            label.text = data["description"] as? String
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 20.0)
            label.textColor = UIColor.gray
            label.center.x = view.center.x
            cibleScrollView.addSubview(label)
            
            // Taux de reduction de la promo
            let frameTaux = CGRect(x: view.center.x , y: frameName.maxY + 10, width: 250, height: 14 )
            
            let labelTaux = UILabel(frame: frameTaux)
            labelTaux.text = data["reduction"] as? String
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
            labelUse.text = data["count"] as? String
            labelUse.textAlignment = .center
            labelUse.textColor = UIColor.lightGray
            labelUse.center.x = view.center.x
            cibleScrollView.addSubview(labelUse)
            
            i += 1
        }
    }
    
    @objc func imageButtonTapped(_ sender:UIButton!)
    {
        print("Clic clic")
        print(sender.tag)
        let theChoice = sender.tag
        sendPromo(monchoix: theChoice)
        spinner1.startAnimating()
        getPromo()
        showPromoPerso()
        
        // recharger la page :  En gros refaire le viewdidload.
       
        changementView(cible: "storyPromo")        // methode a changer car pas optimal
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
                
                if  let idClient = result.data.idcli{
                    idClientFind = idClient
                }
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
        let urlTest = URL(string: "http://" + ipServ + ":8484/orkecom/api/client/offers/available")
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
                let result = try decoder.decode(ListeOffreDisponible.self, from: content)
                
                self.listeSpecial = []
                
                for offreDispo in result.offers {
                    self.listeSpecial.append(offreDispo)
                }
                
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    func sendPromo(monchoix: Int){
        let ip = ""
        let ipServ = ip.getIp()
        let url = URL(string: "http://" + ipServ + ":8484/orkecom/api/client/offers/select")
        var request : URLRequest
        request = createReponseRequestPromoChoix(idcli: idClientFind, url: url!, choix: monchoix)
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { data, response, error in
            
            // ensure there is no error for this HTTP response
            guard error == nil else {
                print ("error: \(error!)")
                return
            }
            
            // ensure there is data returned from this HTTP response
            guard data != nil else {
                print("No data")
                return
            }
        }
        task.resume()
    }
    
    // requete pour recuperer les offres
    func createReponseRequestIdcli(idcli : String, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // prepare json data
        let json: [String: Any] = ["idcli": idcli]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        
        return request
    }
    
    // requête pour selectionner une offre
    func createReponseRequestPromoChoix(idcli : String, url: URL, choix: Int) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let selectOffre = "[" + String(choix) + "]"
        let json: [String: Any] = ["idcli": idcli,
                                   "offers": selectOffre ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        
        return request
    }
    
    @IBAction func showMenu(_ sender: Any) {
        showSideMenu()
    }
    
    // Fonction génériques :
    
    func changementView(cible : String){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Promo", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: cible)
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    // Fonction de gestion de couleur
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
}
