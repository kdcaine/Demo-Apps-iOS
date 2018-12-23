//
//  CustomMenuSlideView.swift
//  Ezgo
//
//  Created by Puagnol John on 14/12/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit

class CustomMenuSlideView: UIView {


    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        layer.cornerRadius = 15
        layer.borderColor = BLUE_COLOR.cgColor
        layer.borderWidth = 2
//        backgroundColor = .darkGray
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: -4, height: 4)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.65
    }

}
