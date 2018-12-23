//
//  InfoArticleController.swift
//  Ezgo
//
//  Created by Puagnol John on 14/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit
import CoreData

class InfoArticleController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var imgArticle: UIImageView!
    @IBOutlet weak var nomArticle: UILabel!
    @IBOutlet weak var prixUnitaire: UILabel!
    @IBOutlet weak var quantiteArticle: UILabel!
    @IBOutlet weak var montantTotalArticle: UILabel!
    @IBOutlet weak var titreValeur: UILabel!
    @IBOutlet weak var zoneArticle: UIScrollView!
    @IBOutlet weak var loadingIcone: UIActivityIndicatorView!
    @IBOutlet weak var zoneAffichage: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var articleInformation = [ArticleDetail]()
    var position = 0
    
    var nutriments = [ArticleInformation]()
    
    let identifiantCell = "ArticleCellNutri"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //        self.titreValeur.text = ""
        self.imgArticle.image = UIImage(named: "no_image")
        
        if let codeArticle = articleInformation.first?.ean{
            
            GetInfoArticle.getInfoArticle(code: codeArticle) { (resultat) in
                
                if resultat.first?.status != 0 {
                    
                    // on recupere l'image :
                    
                    if let imageFind = resultat.first?.product?.image{
                        self.imgArticle.load(url: imageFind)
                    }
                    
                    self.nutriments = [ArticleInformation]()
                    let infoNutri1 = ArticleInformation(nomNutriments: "energie", valNutriments: (resultat.first?.product?.nutriments?.energie)!)
                    self.nutriments.append(infoNutri1)
                    let infoNutri2 = ArticleInformation(nomNutriments: "proteine", valNutriments: (resultat.first?.product?.nutriments?.proteine)!)
                    self.nutriments.append(infoNutri2)
                    let infoNutri3 = ArticleInformation(nomNutriments: "sucre", valNutriments: (resultat.first?.product?.nutriments?.sucre)!)
                    self.nutriments.append(infoNutri3)
                    let infoNutri4 = ArticleInformation(nomNutriments: "glucide", valNutriments: (resultat.first?.product?.nutriments?.glucide)!)
                    self.nutriments.append(infoNutri4)
                    let infoNutri5 = ArticleInformation(nomNutriments: "sel", valNutriments: (resultat.first?.product?.nutriments?.sel)!)
                    self.nutriments.append(infoNutri5)
                    let infoNutri6 = ArticleInformation(nomNutriments: "graisse", valNutriments: (resultat.first?.product?.nutriments?.graisse)!)
                    self.nutriments.append(infoNutri6)
                    let infoNutri7 = ArticleInformation(nomNutriments: "graisse_sature", valNutriments: (resultat.first?.product?.nutriments?.graisse_sature)!)
                    self.nutriments.append(infoNutri7)
                    let infoNutri8 = ArticleInformation(nomNutriments: "fibre", valNutriments: (resultat.first?.product?.nutriments?.fibre)!)
                    self.nutriments.append(infoNutri8)
                    
                    
                }
            }
        }
        
        if let labelArticle = articleInformation.first?.nom{
            nomArticle.text = labelArticle
        }
        
        if let prixNArticle = articleInformation.first?.prixNet{
            montantTotalArticle.text = String(prixNArticle) + " €"
        }
        
        if let priUArticle = articleInformation.first?.prixUttc{
            prixUnitaire.text = String(priUArticle) + " € /u"
        }
        
        if let qteArticle = articleInformation.first?.qte{
            quantiteArticle.text = "x " + String(qteArticle)
        }
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.loadingIcone.removeFromSuperview()
            self.tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nutriments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let article = nutriments[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCellNutri") as? DetailArticleCell {
            
            cell.creerCell(article)
            return cell
        }
        return  UITableViewCell()
    }
    
    
    // definir la hauteur de chaque cellule
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    ////////////////////////////////////////////////////
    ////////////////////////////////////////////////////
    
}
