//
//  CategorieController.swift
//  Ezgo
//
//  Created by Puagnol John on 13/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit

class CategorieController: UIViewController {

    @IBOutlet weak var zoneCategorie: UIView!
    @IBOutlet weak var titre: UILabel!
    @IBOutlet weak var nomCatalogue: UILabel!
    
    var tagValue = 100
    var viewTagValue = 10
    
    var monCatalogue = ""
    var position = 0
    var lesPages : [[String]] = []
    var indexDicoSend = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dico = monCatalogue.convertToTabDictionary()
        
        var goodPub = dico![position]
        let donneeCatalogue = goodPub["categories"] as? [[String: Any]]
        
        //        print("les catalogues")
        //        print(donneeCatalogue)
        
        var i = 0
        for myCategorie in donneeCatalogue! {
            
            let nomCategorie = myCategorie["lib"] as? String
            
            createButton(name: nomCategorie!, cpt: i)
            
            let pagesFullCatalogue = myCategorie["pages"] as? [[String: Any]]
            
            var maListPage : [String] = []
            for pages in pagesFullCatalogue! {
                let myPage = pages["urlImg"] as? String
                maListPage.append(myPage!)
            }
            lesPages.append(maListPage)
            
            i += 1
        }
        
        // recupere le nom du catalogue en fonction de la positon envoyé depuis le segue.
        if position == 0 {
            nomCatalogue.text = "Catalogue du moment"
        } else {
            nomCatalogue.text = "Prochain catalogue"
        }
    }
    
    func createButton(name: String, cpt: Int) {
        
        let imageSize : CGFloat = 90
        let gap : CGFloat = 10
        let borderSize : CGFloat = 10
        let textHeight : CGFloat = 20
        let imageOrigin : CGFloat = borderSize + gap
        let textTop : CGFloat = imageOrigin + imageSize + gap
        let textBottom : CGFloat = borderSize + gap
        let imageBottom : CGFloat = textBottom + textHeight + gap
        
        
        
        let button = UIButton();
        let tailleY = Int(titre.frame.height) + 70 // la taille + les marges
        let largeurEcran = Int(self.view.frame.width)
        button.frame = CGRect(x: 20, y: tailleY + 160 * cpt, width: largeurEcran - 40, height: 150)
        button.backgroundColor = UIColor.orange
        
        button.tag = cpt
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.arrondissementBouton()
        
        var imgName = ""
        
        switch name {
            case "tout":
                imgName = "cat_all"
            case "La boucherie pei":
                imgName = "cat_food"
            case "La charcuterie":
                imgName = "cat_charcuterie"
            case "L'entretien":
                imgName = "cat_entretien"
            case "La foire au plastique":
                imgName = "cat_plastic"
            default:
                imgName = "cat_promo"
        }
        
        
        // Image
        let myImage = UIImage(named: imgName)
        let positonImg = CGFloat((largeurEcran - 40) / 4)
        button.setImage(myImage, for: UIControl.State.normal)
        button.imageEdgeInsets = UIEdgeInsets(top: imageOrigin, left: positonImg,  bottom: imageBottom, right: positonImg)
        button.imageView?.contentMode = .scaleAspectFit
        
        //Text
        button.setTitle(name.uppercased(), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: textTop, left: -myImage!.size.width, bottom: textBottom, right: 0.0)
        
        
        self.zoneCategorie.addSubview(button)
    }
    
    
    @objc func buttonAction(sender: CustomView!) {
        let btnsendtag: CustomView = sender
        
        indexDicoSend = btnsendtag.tag
        performSegue(withIdentifier: "segueCataFinal", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCataFinal" {
            let vc = segue.destination as! ShowCatalogueController
            vc.mesPages = lesPages[indexDicoSend]
            vc.monCatalogue = self.monCatalogue
            vc.position = self.position
        }
        
    }
}
