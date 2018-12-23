//
//  ArticleCell.swift
//  Ezgo
//
//  Created by Puagnol John on 14/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {
    
    @IBOutlet weak var labelArticle: UILabel!
    @IBOutlet weak var prix1: UILabel!
    @IBOutlet weak var prix2: UILabel!
    @IBOutlet weak var imageArticle: UIImageView!
    
    @IBOutlet weak var quantite: UILabel!
    
    var article: ArticleDetail!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func creerCell(_ article: ArticleDetail, position: Int){
        self.article = article
        
        let attributed = NSMutableAttributedString(string: self.article.nom, attributes: [.font: UIFont.boldSystemFont(ofSize: 20), .foregroundColor: UIColor.black])
        
        labelArticle.attributedText = attributed
        
        //puttc
        let attributed1 = NSMutableAttributedString(string: String(self.article.prixUttc) + " €", attributes: [.font: UIFont.boldSystemFont(ofSize: 20), .foregroundColor: UIColor.black])
        
        prix1.attributedText = attributed1
        
        //netttc
        let attributed2 = NSMutableAttributedString(string: String(self.article.prixNet), attributes: [.font: UIFont.boldSystemFont(ofSize: 20)])
        
        prix2.attributedText = attributed2
        
        let attributedQuantite = NSMutableAttributedString(string: String(self.article.qte))
        
        quantite.attributedText = attributedQuantite
        
        let tabTest = ["3560239276388","356028911662","3560239491774","6941057400068","8710103807407","3165140761345","3276000228042","3276000060437","4892210138101","3560239440680","6901570083216","8718863015957"]
        
        var testImage = false
        
        print(self.article.ean)
        
        // TODO : appliquer le code sur le net pour voir si image existe deja
        
        for ean in tabTest {
            if ean == self.article.ean {
                imageArticle.image = UIImage(named: "j_" + ean)
                testImage = true
            }
        }
        
        if testImage == false {
            ImageFood.afficheImage(code: self.article.ean, imageArticle: self.imageArticle )
        }
    }
}
