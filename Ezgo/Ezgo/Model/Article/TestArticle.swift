//
//  TestArticle.swift
//  Ezgo
//
//  Created by Puagnol John on 14/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TestArticle {
    
    static func getResponse(ficheClient : String, saveEAN: Int, articleScanner : String, completion: @escaping (_ result: Bool)->()){
        
        var testDuEan = true
        
        var request : URLRequest
        
        request = creerTickets(ficheClientRequete: ficheClient, articleScannerRequete: articleScanner)
        
        let session = URLSession(configuration: .default)
        
        
        let task = session.dataTask(with: request) { data, response, error in
            
            // ensure there is no error for this HTTP response
            guard error == nil else {
                print ("error: \(error!)")
                return
            }
            
            // ensure there is data returned from this HTTP response
            guard let content = data else {
                print("No data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(DonneeValorize.self, from: content)
                
                let status = result.status
                
                if status == 200{
                    
                    print("Code valide pour le TestArticle ")
                    
                    print("code bar de l'article : ", articleScanner)
                    
                    if saveEAN == 1 {
                        let ajouterEAN = ArticleEAN(context: contexte)
                        ajouterEAN.ean = articleScanner
                        ajouterEAN.qte = 1
                        appDelegate.saveContext()
                    } else {
                        let ajouterEAN = ArticleCommandeEAN(context: contexte)
                        ajouterEAN.ean = articleScanner
                        ajouterEAN.qte = 1
                        appDelegate.saveContext()
                    }
                    
                    testDuEan = true
                } else {
                    
                    // Todo : afficher le message erreur
                    print("Code ean non valide !")
                    
                    testDuEan = false
                    
                    let eanInconnu = try decoder.decode(DonneeValorizeError.self, from: content)
                    
                    let codeErreur = eanInconnu.errors.last?.code
                    
                    print("code erreur : ", codeErreur as Any)
                }
            } catch {
                print(error)
                testDuEan = false
            }
            completion(testDuEan)
        }
        
        task.resume()
    }
    
    private static func creerTickets(ficheClientRequete : String, articleScannerRequete : String) -> URLRequest {
        
        let ip = ""
        let ipServ = ip.getIp()
        
        let url = URL(string: "http://" + ipServ + ":8484/orkecom/api/cart/valorize")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // prepare json data
        let json: [String: Any] = ["idtrs": String(arc4random()),       // genere un nombre aleatoire
            "typtrt":1,
            "client":ficheClientRequete,             // donnée client recu à la connexion
            "ticket":"[{\"ean\":\"" + articleScannerRequete + "\"}]"]         // JSON de ean
        
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        
        return request
    }
}

