//
//  ListeList.swift
//  Ezgo
//
//  Created by Puagnol John on 15/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import Foundation

class ListeList {
    
    private var _liste: String
    
    var titre_liste: String{
        return _liste
    }
    
    init(titre_liste: String){
        self._liste = titre_liste
    }
}
