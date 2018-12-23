//
//  InfoArticleNoFoodController.swift
//  Ezgo
//
//  Created by Puagnol John on 14/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit

class InfoArticleNoFoodController: UIViewController {
    
    @IBOutlet weak var imgArticle: UIImageView!
    @IBOutlet weak var nomArticle: UILabel!
    @IBOutlet weak var prixUnitaire: UILabel!
    @IBOutlet weak var quantiteArticle: UILabel!
    @IBOutlet weak var montantTotalArticle: UILabel!
    @IBOutlet weak var zoneArticle: UIScrollView!
    @IBOutlet weak var loadingIcone: UIActivityIndicatorView!
    @IBOutlet weak var zoneAffichage: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var articleInformation = [ArticleDetail]()
    var my_description = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.imgArticle.image = UIImage(named: "no_image")
        
        if let codeArticle = articleInformation.first?.ean{
            
            //Todo : recupérer une image deja dl
            
            //imgArticle.image = UIImage(named: "i_" + codeArticle)
            
            GetInfoArticleNoFood.getInfoArticle(code: codeArticle) { (resultat) in
                
                let description = resultat.first?.data?.records.first?.jret?.article?.descript
                let final_description = description!.replacingOccurrences(of: "<br>", with: "\n")
                self.my_description = final_description
                
                let tabImage = resultat.first?.data?.records.first?.jret?.article?.img
                
                let firstImage = tabImage?.first
                
                let ip = ""
                let ipServ = ip.getIp()
                
                let urlImage = URL(string: "http://" + ipServ + ":8080" + firstImage!)
                self.imgArticle.load(url: urlImage!)
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
        
        self.loadingIcone.removeFromSuperview()
        
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.descriptionLabel.text = self.my_description
            self.descriptionLabel.sizeToFit()
        }
    }
}
