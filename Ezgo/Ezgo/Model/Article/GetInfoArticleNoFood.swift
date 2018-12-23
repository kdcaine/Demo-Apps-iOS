//
//  GetInfoArticleNoFood.swift
//  Ezgo
//
//  Created by Puagnol John on 14/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import Foundation
import UIKit

class GetInfoArticleNoFood {
    
    struct ArticleDescription: Codable {
        let status: Int?
        let data: Detail?
        
        enum CodingKeys: String, CodingKey {
            case status, data
        }
    }
    
    struct Detail: Codable {
        let total: Int?
        let records: [Records]
        
        enum CodingKeys: String, CodingKey {
            case total, records
        }
    }
    
    struct Records: Codable {
        let jret: FullJret?
        
        enum CodingKeys: String, CodingKey {
            case jret
        }
    }
    
    struct FullJret: Codable {
        let article: InfoFinal?
        
        enum CodingKeys: String, CodingKey {
            case article = "article_information"
        }
    }
    
    struct InfoFinal: Codable {
        let descript: String?
        let img: [String]
        
        enum CodingKeys: String, CodingKey {
            case descript = "description1"
            case img = "img_url"
        }
    }
    
    static func getInfoArticle(code: String, completion: @escaping (_ result: [GetInfoArticleNoFood.ArticleDescription])->()){
        
        var request : URLRequest
        
        request = getTokenAPI()
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data, error == nil {
                
                if let stringFind = String(data: data, encoding: .utf8) {
                    
                    // Return un JSON pour la récupération de token.
                    let jsonResponseToken = stringFind.convertToDictionary()
                    
                    let token = jsonResponseToken!["access_token"]
                    
                    let ip = ""
                    let ipServ = ip.getIp()
                    
                    let urlObj = URL(string: "http://" + ipServ + ":7998/ez/api/v1/articles/" + code)
                    
                    // create post request
                    var requestFinal = URLRequest(url: urlObj!)
                    requestFinal.httpMethod = "GET"
                    
                    requestFinal.setValue( "Bearer \(token!)", forHTTPHeaderField: "Authorization")
                    
                    let taskFinal = URLSession.shared.dataTask(with: requestFinal) { dataT, response, error in

                        // ensure there is no error for this HTTP response
                        guard error == nil else {
                            print ("error: \(error!)")
                            return
                        }
                        
                        // ensure there is data returned from this HTTP response
                        guard let content = dataT else {
                            print("No data")
                            return
                        }
                        
                        if let articleFullDetail = String(data: content, encoding: .utf8) {
                            
                            let monDico = "[" + articleFullDetail + "]"
                            let dataMonDico = monDico.data(using: .utf8)!
                            do {
                                
                                let decoder = JSONDecoder()
                                let result = try decoder.decode([ArticleDescription].self, from: dataMonDico)
                                
                                completion(result)
                                
                            } catch {
                                print(error)
                            }
                        }
                    }
                    taskFinal.resume()
                    
                } else {
                    print("not a valid UTF-8 sequence")
                }
                
            } else {
                print("erreur d'envoye")
            }
        }
        task.resume()
    }
    
    private static func getTokenAPI() -> URLRequest {
        
        let ip = ""
        let ipServ = ip.getIp()
        
        let urlToken = URL(string: "http://" + ipServ + ":7998/ez/api/v1/login/connect")!
        
        var request = URLRequest(url: urlToken)
        request.httpMethod = "POST"
        
        // prepare json data
        let json: [String: Any] = [
            "q.idu": "info",
            "q.pwd": "caf9b6b99962bf5c2264824231d7a40c"
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        return request
    }
}
