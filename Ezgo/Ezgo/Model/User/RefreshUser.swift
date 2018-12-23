//
//  RefreshUser.swift
//  Ezgo
//
//  Created by Puagnol John on 14/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RefreshUser {
    
    static func getResponse(idco : String, completion: @escaping (_ result: String)->()){
        
        var donneeFullClient = ""
        
        var request : URLRequest
        
        // Connexion par idcli
        request = createReponseRequestIdcli(idcli: idco)
        
        
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
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                print("status 200")

                // On supprime l'ancien client :
                deleteAllRecords(entity: "DonneeClient")
                
                // Ajout les données du client dans le core Data
                let donneeComplete = DonneeClient(context: contexte)
                donneeComplete.client = content
                appDelegate.saveContext()

                print("refresh client")

                if let stringContent = String(data: content, encoding: .utf8) {
                    
                    let dicoContent = stringContent.convertToDictionary()
                    let myDico = dicoContent!["data"] as Any
                    
                    let dicoString = stringify(json: myDico)
                
                    donneeFullClient = dicoString
                }
                completion(donneeFullClient)
            }
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
    
    private static func jsonToString(json: AnyObject) -> String{
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            print(convertedString ?? "defaultvalue")
            return convertedString ?? "defaultvalue"
        } catch let myJSONError {
            print(myJSONError)
            return "erreur"
        }
        
    }
    
    private static func stringify(json: Any, prettyPrinted: Bool = false) -> String {
        var options: JSONSerialization.WritingOptions = []
        if prettyPrinted {
            options = JSONSerialization.WritingOptions.prettyPrinted
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: options)
            if let string = String(data: data, encoding: String.Encoding.utf8) {
                return string
            }
        } catch {
            print(error)
        }
        
        return ""
    }
}
