//
//  CommandeCell.swift
//  Ezgo
//
//  Created by Puagnol John on 13/12/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit

class CommandeCell: UITableViewCell {
    
    @IBOutlet weak var dateOrder: UILabel!
    @IBOutlet weak var priceOrder: UILabel!
    @IBOutlet weak var numOrder: UILabel!
    
    
    var maCommande: ListeOrder!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func creerCell(_ myOrder: ListeOrder){
        self.maCommande = myOrder
        
        let attributed = NSMutableAttributedString(string: self.maCommande.date, attributes: [:])
        dateOrder.attributedText = attributed
        
        let attributed1 = NSMutableAttributedString(string: String(self.maCommande.prixNet) + " €", attributes: [:])
        
        priceOrder.attributedText = attributed1
        
        //code
        let attributed2 = NSMutableAttributedString(string: "n° : " + String(self.maCommande.code), attributes: [:])
        
        numOrder.attributedText = attributed2
        
    }

}
