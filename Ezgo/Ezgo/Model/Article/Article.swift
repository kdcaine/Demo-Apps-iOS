//
//  Article.swift
//  Ezgo
//
//  Created by Puagnol John on 14/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Article {
    
    static func getResponse(ficheClient : String, articleScanner : String, ajoutArticle : Bool, completion: @escaping (_ result: Bool)->()){
        
        var etat = false
        
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
            
            if ajoutArticle {
                print("on ajoute le nouvelle article : Model Article")
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(DonneeValorize.self, from: content)
                    
                    let status = result.status
                    
                    if status == 200{
                        
                        let allTicket = result.data.ticket
                        
                        if let ticket = allTicket.last {
                            print("nom article dans la boucle : ", ticket.lib as Any )
                            let ajoutArticle = TicketGestion(context: contexte)
                            ajoutArticle.netttc = ticket.netttc
                            ajoutArticle.puttc = ticket.puttc
                            ajoutArticle.lib = ticket.lib
                            ajoutArticle.ean = ticket.ean
                            ajoutArticle.qte = ticket.qte
                            ajoutArticle.ticketTotal = content
                            
                            appDelegate.saveContext()
                        }
                    }
                } catch {
                    print(error)
                }
                etat = true
            }
            else {
                
                deleteAllRecords(entity: "TicketGestion")
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(DonneeValorize.self, from: content)
                    
                    let status = result.status
                    
                    if status == 200{
                        
                        let allTicket = result.data.ticket
                        
                        for ticket in allTicket{
                            print("nom article dans la boucle : ", ticket.lib as Any )
                            let ajoutArticle = TicketGestion(context: contexte)
                            ajoutArticle.netttc = ticket.netttc
                            ajoutArticle.puttc = ticket.puttc
                            ajoutArticle.lib = ticket.lib
                            ajoutArticle.ean = ticket.ean
                            ajoutArticle.qte = ticket.qte
                            ajoutArticle.ticketTotal = content
        
                            appDelegate.saveContext()
                        }
                    }
                } catch {
                    print(error)
                }
                etat = true
            }
            
            print("Etat : ", etat)
            completion(etat)
            
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
            "ticket":"[" + articleScannerRequete + "]"]         // JSON de ean
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        
        return request
    }
    
    private static func deleteAllRecords(entity: String) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
}

