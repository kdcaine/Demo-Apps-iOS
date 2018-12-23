//
//  Finalize.swift
//  Ezgo
//
//  Created by Puagnol John on 14/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Finalize {
    
    static func getResponse(ficheClient : String, articleScanner : String, caisseScanner: String){
        
        var request : URLRequest
        
        request = creerTickets(ficheClientRequete: ficheClient, articleScannerRequete: articleScanner, caisseScannerRequete: caisseScanner)
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data, error == nil {
                
                if let stringFind = String(data: data, encoding: .utf8) {
                    
                    // Return un Json avec ctrl si 0 donc on doit pas verifier
                    print(stringFind)
                    
                } else {
                    print("not a valid UTF-8 sequence")
                }
                
            } else {
                print("erreur d'envoye")
            }
        }
        task.resume()
        
    }
    
    private static func creerTickets(ficheClientRequete : String, articleScannerRequete : String, caisseScannerRequete: String) -> URLRequest {
        
        let ip = ""
        let ipServ = ip.getIp()
        
        let url = URL(string: "http://" + ipServ + ":8484/orkecom/api/cart/finalize")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
                
        let dico = ficheClientRequete.convertToDictionary()
        var idtrs: String = ""
        
        idtrs = dico!["idcli"] as! String
        
        // affiche date et heure a ajouter dans le valorize.
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyyMMddHHmmss"
        
        let result = formatter.string(from: date)
        
        idtrs += result
        
        // prepare json data
        let json: [String: Any] = ["idtrs": idtrs,       // genere un nombre aleatoire
            "typtrt":1,
            "client":ficheClientRequete,             // donnée client recu à la connexion
            "idpos": caisseScannerRequete,
            "ticket":"[" + articleScannerRequete + "]"]         // JSON de ean
        
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        return request
    }
}

