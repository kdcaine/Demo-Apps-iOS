//
//  Connexion.swift
//  Ezgo
//
//  Created by Puagnol John on 22/10/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//


import Foundation
import UIKit
import CoreData

class Connexion {
    
    static func getResponse(idco : String, choixCo : Int, completion: @escaping (_ result: [String: Any])->()){
        
        
        var infoConnexion = [String:Any]()
        
        infoConnexion["etat"] = false
        
        var request : URLRequest
        
        // Connexion par idcli
        if choixCo == 1{
            request = createReponseRequestIdcli(idcli: idco)
        } else {
            request = createReponseRequestMail(mail: idco)
        }
        
        deleteAllRecords(entity: "DonneeClient")
        
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
                let result = try decoder.decode(TestConnection.self, from: content)

                let status = result.status
                                
                if status == 200{
                    
                    let myClient = try decoder.decode(CompteUser.self, from: content)
                    
                    let finalStatus = myClient.data.head.status
                    
                    if finalStatus == "0"{
                        
                        let donneeComplete = DonneeClient(context: contexte)
                        donneeComplete.client = data
                        appDelegate.saveContext()
                        
                        print("connexion ok ")
                        // On envoye la communication en mode emetteur pour le controleur.
                        let name = Notification.Name(rawValue: "ConnexionOK")
                        let notification = Notification(name: name)
                        NotificationCenter.default.post(notification)
                        infoConnexion["etat"] = true

                    } else {
                        infoConnexion["etat"] = false
                        infoConnexion["erreur"] = 44
                        print("error")
                    }
                    
                } else {
                    
                    let myClient = try decoder.decode(ErrorConnexion.self, from: content)
                    print(myClient)
                    infoConnexion["etat"] = false
                    infoConnexion["erreur"] = myClient.errors[0].code

                }

            } catch {
                infoConnexion["etat"] = false
                infoConnexion["erreur"] = 44
                print(error)
            }
            completion(infoConnexion)
        }
        task.resume()
    }
    

    
    private static func createReponseRequestIdcli(idcli : String) -> URLRequest {
        
        let ip = ""
        let ipServ = ip.getIp()
        
        let url = URL(string: "http://" + ipServ + ":8484/orkecom/api/client/info")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // prepare json data
        let json: [String: Any] = ["idcli": idcli,
                                   "idens": 1,
                                   "idm":999]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        
        return request
    }
    
    private static func createReponseRequestMail(mail : String) -> URLRequest {
        
        let ip = ""
        let ipServ = ip.getIp()
        
        let url = URL(string: "http://" + ipServ + ":8484/orkecom/api/client/info")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // prepare json data
        let json: [String: Any] = ["email": mail,
                                   "idens": 1,
                                   "idm":999]
        
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

