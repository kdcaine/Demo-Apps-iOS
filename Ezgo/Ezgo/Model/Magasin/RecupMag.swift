//
//  RecupMag.swift
//  Ezgo
//
//  Created by Puagnol John on 12/12/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RecupMag {
    
    static func getMag(completion: @escaping (_ result: [Magasin])->()){
        
        var maListeDeMagasin = [Magasin]()
        
        let ip = ""
        let ipServ = ip.getIp()
        
        let myUrl = URL(string: "http://" + ipServ + ":8484/orkecom/api/data/stores")!
        
        var request = URLRequest(url: myUrl)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
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
                let result = try decoder.decode(ListeMagasin.self, from: content)
                
                let status = result.status
                
                if status == 200{
                    maListeDeMagasin = result.data
                }
                
            } catch {
                print(error)
            }
            
            completion(maListeDeMagasin)
            
        }
        task.resume()
        
    }
}
