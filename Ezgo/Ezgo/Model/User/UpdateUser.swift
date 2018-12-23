//
//  UpdateUser.swift
//  Ezgo
//
//  Created by Puagnol John on 13/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import Foundation

class UpdateUser {
    
    static func getResponse(idcli: String, mail : String, adresse : String, cp : String, ville : String, pays: String, tel: String){
        let request = createReponseReques(idUser: idcli, mailUser: mail, adresseUser: adresse, cpUser: cp, villeUser: ville, paysUser: pays, telUser: tel)
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let _ = data, error == nil {
                
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    print("status 200")
                    
                    Connexion.getResponse(idco: idcli, choixCo: 1) { (result) -> () in        // type mail
                        
                    }
                }
            } else {
                print("erreur d'envoye")
            }
        }
        task.resume()
    }
    
    private static func createReponseReques(idUser : String, mailUser : String, adresseUser : String, cpUser : String, villeUser : String, paysUser : String, telUser: String) -> URLRequest {
        
        let ip = ""
        let ipServ = ip.getIp()
        
        let url = URL(string: "http://" + ipServ + ":8484/orkecom/api/client/update")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let json: [String: Any] = ["idcli": idUser,
                                   "email": mailUser,
                                   "adr1": adresseUser,
                                   "cp": cpUser,
                                   "ville": villeUser,
                                   "pays": paysUser,
                                   "tel": telUser,
                                   "idens": 1,
                                   "idm":999]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        return request
    }
}
