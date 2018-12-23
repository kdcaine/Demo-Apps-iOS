//
//  ArticleDetail.swift
//  Ezgo
//
//  Created by Puagnol John on 14/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import Foundation

class ArticleDetail {
    
    private var _ean: String
    private var _lib: String
    private var _prixNet: Double
    private var _prixUttc: Double
    private var _qte: Int
    
    var ean: String{
        return _ean
    }
    
    var nom: String{
        return _lib
    }
    
    var prixNet: Double {
        return _prixNet
    }
    
    var prixUttc: Double {
        return _prixUttc
    }
    
    var qte: Int{
        return _qte
    }
    
    
    
    init(ean: String, nom: String, prixNet: Double, prixUttc: Double, qte: Int){
        self._ean = ean
        self._lib = nom
        self._prixNet = prixNet
        self._prixUttc = prixUttc
        self._qte = qte
    }
}
