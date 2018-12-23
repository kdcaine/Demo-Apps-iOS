//
//  ArticleCommandeCell.swift
//  Ezgo
//
//  Created by Puagnol John on 16/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit

class ArticleCommandeCell: UITableViewCell {
    
    @IBOutlet weak var labelArticle: UILabel!
    @IBOutlet weak var prix1: UILabel!
    @IBOutlet weak var prix2: UILabel!
    @IBOutlet weak var quantite: UILabel!
    
    var article: ArticleDetail!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func creerCell(_ article: ArticleDetail, position: Int){
        self.article = article
        
        let attributed = NSMutableAttributedString(string: self.article.nom, attributes: [.font: UIFont.boldSystemFont(ofSize: 20), .foregroundColor: UIColor.black])
        
        labelArticle.attributedText = attributed
        
        //puttc
        let attributed1 = NSMutableAttributedString(string: String(self.article.prixUttc) + " €", attributes: [.font: UIFont.boldSystemFont(ofSize: 20), .foregroundColor: UIColor.black])
        
        prix1.attributedText = attributed1
        
        //netttc
        let attributed2 = NSMutableAttributedString(string: String(self.article.prixNet)  + " €", attributes: [.font: UIFont.boldSystemFont(ofSize: 20)])
        
        prix2.attributedText = attributed2
        
        let attributedQuantite = NSMutableAttributedString(string: "x " + String(self.article.qte))
        
        quantite.attributedText = attributedQuantite
        
        
    }
}
