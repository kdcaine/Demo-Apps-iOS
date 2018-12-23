//
//  ImageFood.swift
//  Ezgo
//
//  Created by Puagnol John on 14/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ImageFood {
    
    struct CatalogItem: Codable {
        let product: Product?
        let status: Int?
        
        enum CodingKeys: String, CodingKey {
            case product, status
        }
    }
    
    struct Product: Codable {
        let image: URL
        
        enum CodingKeys: String, CodingKey {
            case image = "image_small_url"
        }
    }
    
    
    static func afficheImage(code: String, imageArticle: UIImageView){
        
        let myUrl = "https://fr.openfoodfacts.org/api/v0/produit/" + code
        let urlObj = URL(string: myUrl)
        let session = URLSession(configuration: .default)
        
        let request = URLRequest(url: urlObj!)
        
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
            
            if let articleFullDetail = String(data: content, encoding: .utf8) {
                
                
                let monDico = "[" + articleFullDetail + "]"
                let dataMonDico = monDico.data(using: .utf8)!
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode([CatalogItem].self, from: dataMonDico)
                    
                    if result.first?.status == 1 {
                        if let imageFind = result.first?.product?.image{
                            imageArticle.load(url: imageFind)
                        }
                    }
                    
                } catch {
                    print(error)
                }
                
            }
        }
        task.resume()
        
    }
}
