//
//  GestionArticleJSON.swift
//  Ezgo
//
//  Created by Puagnol John on 06/12/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import Foundation


struct DonneeValorize: Codable {
    let data: DataValorize
    let status: Int
    
    enum CodingKeys: String, CodingKey {
        case data, status
    }
}

struct DonneeValorizeError: Codable {
    let errors: [ErrorValorize]
    let status: Int
    
    enum CodingKeys: String, CodingKey {
        case errors, status
    }
}

struct DataValorize: Codable {
    let idcli: String?
    let idtrs: String?
    let total: TotalTicket
    let ticket: [TicketValorize]
    
    enum CodingKeys: String, CodingKey {
        case  idcli, idtrs, total, ticket
    }
}

struct TotalTicket: Codable {
    let netttcb: Double
    let netttc: Double
    
    enum CodingKeys: String, CodingKey {
        case  netttcb, netttc
    }
}

struct TicketValorize: Codable {
    let qte: Int16
    let netttc: Double
    let lib: String?
    let netttcb: Double
    let ean: String?
    let puttc: Double
    let puht: Double
    let idr: Int
    
    enum CodingKeys: String, CodingKey {
        case  qte, netttc, lib, netttcb, ean, puttc, puht, idr
    }
}

struct ErrorValorize: Codable{
    let code: Int
    
    enum CodingKeys: String, CodingKey{
        case code
    }
}
