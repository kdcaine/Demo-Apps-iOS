//
//  Save.swift
//  Ezgo
//
//  Created by Puagnol John on 16/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Save {
    
    private static var orderCode = ""
    
    static func getResponse(ficheClient : String, articleScanner : String, completion: @escaping (_ result: String)->()){
    
        
        print("list item = " + articleScanner)
        
        var request : URLRequest
        
        request = creerTickets(ficheClientRequete: ficheClient, articleScannerRequete: articleScanner)
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data, error == nil {
                
                if let stringFind = String(data: data, encoding: .utf8) {
                    
                    print("code commande : ", orderCode)
                    // Return un Json avec ctrl si 0 donc on doit pas verifier
                    print(stringFind)
                    
                } else {
                    print("not a valid UTF-8 sequence")
                }
            } else {
                print("erreur d'envoye")
            }
            completion(orderCode)
        }
        task.resume()
        
    }
    
    private static func creerTickets(ficheClientRequete : String, articleScannerRequete : String) -> URLRequest {
        
        let ip = ""
        let ipServ = ip.getIp()
        
        let url = URL(string: "http://" + ipServ + ":8484/orkecom/api/cart/save")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let dico  = ficheClientRequete.convertToDictionary()
        var idtrs: String = ""
        
        idtrs = dico!["idcli"] as! String
        
        // affiche date et heure a ajouter dans le valorize.
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyyMMddHHmmss"
        
        let result = formatter.string(from: date)
        
        idtrs += result
        
//        print("numero commande : " + idtrs)
        
        orderCode = idtrs
        
        
        // prepare json data
        let json: [String: Any] = ["idtrs": idtrs,       // genere un nombre aleatoire
            "typtrt":1,
            "client":ficheClientRequete,             // donnée client recu à la connexion
            "idpos": "9001000010014",
            "ticket":"[" + articleScannerRequete + "]"]         // JSON de ean
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        return request
    }
}
