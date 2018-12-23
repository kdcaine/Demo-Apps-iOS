//
//  ListeCell.swift
//  Ezgo
//
//  Created by Puagnol John on 15/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit

class ListeCell: UITableViewCell {

    @IBOutlet weak var nameList: UILabel!
    
    var myList: ListeList!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func creerCell(_ myList: ListeList){
        self.myList = myList
        
        let attributed = NSMutableAttributedString(string: self.myList.titre_liste, attributes: [.font: UIFont.boldSystemFont(ofSize: 20), .foregroundColor: UIColor.black])
        nameList.attributedText = attributed
        
    }
}
