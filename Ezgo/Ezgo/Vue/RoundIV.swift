//
//  RoundIV.swift
//  Ezgo
//
//  Created by Puagnol John on 14/12/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit

class RoundIV: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        clipsToBounds = true
        contentMode = .scaleAspectFill
        layer.cornerRadius = frame.height / 2
        layer.borderColor = BLUE_COLOR.cgColor
        layer.borderWidth = 2
        backgroundColor = UIColor.white
        
    }

}
