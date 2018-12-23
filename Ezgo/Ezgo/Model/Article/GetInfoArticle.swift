//
//  GetInfoArticle.swift
//  Ezgo
//
//  Created by Puagnol John on 14/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import Foundation
import UIKit

class GetInfoArticle {
    
    struct CatalogItem: Codable {
        let code: String?
        let status: Int?
        let product: Product?
        
        enum CodingKeys: String, CodingKey {
            case code , status, product
        }
    }
    
    struct Product: Codable {
        let product_name: String?
        let image: URL
        let nutriments: Nutriment?
        
        enum CodingKeys: String, CodingKey {
            case product_name, nutriments
            case image = "image_small_url"
        }
    }
    
    struct Nutriment: Codable {
        let energie: String?
        let proteine: String?
        let sucre: String?
        let glucide: String?
        let sel: String?
        let graisse: String?
        let graisse_sature: String?
        let fibre: String?
        
        enum CodingKeys: String, CodingKey {
            case energie = "energy_100g"
            case proteine = "proteins_100g"
            case sucre = "sugars_100g"
            case glucide = "carbohydrates_100g"
            case sel = "salt_100g"
            case graisse = "fat_100g"
            case graisse_sature = "saturated-fat_100g"
            case fibre = "fiber_100g"
        }
        
        init(energie: String? = "0", proteine: String? = "0", sucre: String? = "0", glucide: String? = "0", sel: String? = "0", graisse: String? = "0", graisse_sature: String? = "0", fibre: String? = "0") {
            self.energie = energie
            self.proteine = proteine
            self.sucre = sucre
            self.glucide = glucide
            self.sel = sel
            self.graisse = graisse
            self.graisse_sature = graisse_sature
            self.fibre = fibre
        }
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            do {
                if let valueEnergie = try? container.decode(Int.self, forKey: .energie) {
                    energie = String(valueEnergie)
                } else {
                    energie = try container.decode(String.self, forKey: .energie)
                }
            } catch {
                energie = "?"
            }
            /////////////////////////////////////////////////////////////
            /////////////////////////////////////////////////////////////
            do {
                if let valueProteine = try? container.decode(Double.self, forKey: .proteine) {
                    proteine = String(valueProteine)
                } else {
                    proteine = try container.decode(String.self, forKey: .proteine)
                }
            } catch {
                proteine = "?"
            }
            /////////////////////////////////////////////////////////////
            /////////////////////////////////////////////////////////////
            do {
                if let valueSucre = try? container.decode(Double.self, forKey: .sucre) {
                    sucre = String(valueSucre)
                } else {
                    sucre = try container.decode(String.self, forKey: .sucre)
                }
            } catch {
                sucre = "?"
            }
            /////////////////////////////////////////////////////////////
            /////////////////////////////////////////////////////////////
            do {
                if let valueGlucide = try? container.decode(Double.self, forKey: .glucide) {
                    glucide = String(valueGlucide)
                } else {
                    glucide = try container.decode(String.self, forKey: .glucide)
                }
            } catch {
                glucide = "?"
            }
            /////////////////////////////////////////////////////////////
            /////////////////////////////////////////////////////////////
            do {
                if let valueSel = try? container.decode(Double.self, forKey: .sel) {
                    sel = String(valueSel)
                } else {
                    sel = try container.decode(String.self, forKey: .sel)
                }
            } catch {
                sel = "?"
            }
            /////////////////////////////////////////////////////////////
            /////////////////////////////////////////////////////////////
            do {
                if let valueGraisse = try? container.decode(Double.self, forKey: .graisse) {
                    graisse = String(valueGraisse)
                } else {
                    graisse = try container.decode(String.self, forKey: .graisse)
                }
            } catch {
                graisse = "?"
            }
            /////////////////////////////////////////////////////////////
            /////////////////////////////////////////////////////////////
            do {
                if let valueGraisseSature = try? container.decode(Double.self, forKey: .graisse_sature) {
                    graisse_sature = String(valueGraisseSature)
                } else {
                    graisse_sature = try container.decode(String.self, forKey: .graisse_sature)
                }
            } catch {
                graisse_sature = "?"
            }
            /////////////////////////////////////////////////////////////
            /////////////////////////////////////////////////////////////
            do {
                if let valueFibre = try? container.decode(Double.self, forKey: .fibre) {
                    fibre = String(valueFibre)
                } else {
                    fibre = try container.decode(String.self, forKey: .fibre)
                }
            } catch {
                fibre = "?"
            }
            
        }
        
    }
    
    static func getInfoArticle(code: String, completion: @escaping (_ result: [GetInfoArticle.CatalogItem])->()){
        
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
                    completion(result)
                    
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
        
        
    }
    
    
}

