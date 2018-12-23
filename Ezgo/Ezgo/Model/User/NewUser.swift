//
//  NewUser.swift
//  Ezgo
//
//  Created by Puagnol John on 12/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import Foundation

class NewUser {
    
    static func getResponse(form : [String:Any]){
        let request = createReponseReques(fullData: form)
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
                    
                    let myClient = try decoder.decode(CreateNewUser.self, from: content)
                    
                    if let idcliFind = myClient.data.idcli{
                        Connexion.getResponse(idco: idcliFind, choixCo: 1) { (result) -> () in
                            
                        }
                    }
                    
                } else {
                    
                    let myClient = try decoder.decode(ErrorConnexion.self, from: content)
                    print(myClient)
                }
                
            } catch {
                print(error)
            }
        }
  
        task.resume()
        
    }
    
    private static func createReponseReques(fullData : [String:Any]) -> URLRequest {
        
        let ip = ""
        let ipServ = ip.getIp()
        
        let url = URL(string: "http://" + ipServ + ":8484/orkecom/api/client/create")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // prepare json data
        let json: [String: Any] = ["email": fullData["mail"] as! String,
                                   "nom": fullData["nom"] as! String,
                                   "prenom": fullData["prenom"] as! String,
                                   "adr1": fullData["adresse"] as! String,
                                   "cp": fullData["cp"] as! String,
                                   "ville": fullData["ville"] as! String,
                                   "pays": fullData["pays"] as! String,
                                   "gtu": fullData["gtu"] as! Int,
                                   "adp": fullData["adp"] as! Int,
                                   "idens": 1,
                                   "idm":999]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        print("json : ", json)
        
        request.httpBody = jsonData
        
        return request
    }
    
    private static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
