//
//  MenuSlideCell.swift
//  Ezgo
//
//  Created by Puagnol John on 14/12/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit

class MenuSlideCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var imgMenu: UIImageView!
    
    
    func setup(_ string: String, nomImg: String){
        self.setup()
        nameLbl.text = string
        imgMenu.image = UIImage(named: nomImg)
    }

}
