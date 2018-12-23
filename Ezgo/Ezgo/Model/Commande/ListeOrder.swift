//
//  ListeOrder.swift
//  Ezgo
//
//  Created by Puagnol John on 13/12/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import Foundation

class ListeOrder {
    
    private var _code: String
    private var _date: String
    private var _prixNet: Double
    
    var code: String{
        return _code
    }
    
    var date: String{
        return _date
    }
    
    var prixNet: Double {
        return _prixNet
    }
    
    
    init(code: String, date: String, prixNet: Double){
        self._code = code
        self._date = date
        self._prixNet = prixNet
    }
}
