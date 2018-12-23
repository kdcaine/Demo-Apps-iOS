//
//  ArticleInformation.swift
//  Ezgo
//
//  Created by Puagnol John on 14/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import Foundation

class ArticleInformation {
    
    private var _nomNutriments: String
    private var _valeurNutriment: String
    
    var nomNutriments: String {
        return _nomNutriments
    }
    
    var valNutriments: String {
        return _valeurNutriment
    }
    
    init(nomNutriments: String, valNutriments: String) {
        self._nomNutriments = nomNutriments
        self._valeurNutriment = valNutriments
    }
}
