//
//  DetailArticleCell.swift
//  Ezgo
//
//  Created by Puagnol John on 14/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit

class DetailArticleCell: UITableViewCell {
    
    @IBOutlet weak var nomNutriment: UILabel!
    @IBOutlet weak var valNutriments: UILabel!
    @IBOutlet weak var imageNutri: UIImageView!
    
    var nutriment: ArticleInformation!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func creerCell(_ nutriment: ArticleInformation){
        
        self.nutriment = nutriment
        
        imageNutri.image = UIImage(named: self.nutriment.nomNutriments)
        
        
        let attributed = NSMutableAttributedString(string: self.nutriment.nomNutriments)
        nomNutriment.attributedText = attributed
        
        if self.nutriment.valNutriments != "?" {
            if self.nutriment.nomNutriments != "energie" {
                let attributed2 = NSMutableAttributedString(string: self.nutriment.valNutriments + "g")
                valNutriments.attributedText = attributed2
            } else {
                let attributed2 = NSMutableAttributedString(string: self.nutriment.valNutriments + " kCal")
                valNutriments.attributedText = attributed2
            }
        } else {
            let attributed2 = NSMutableAttributedString(string: self.nutriment.valNutriments)
            valNutriments.attributedText = attributed2
        }
        
    }
}
