//
//  GestionJSON.swift
//  Ezgo
//
//  Created by Puagnol John on 23/10/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import Foundation

// ------------------------ Traitement JSON : /offers.json

struct ListeOffreDisponible: Codable {
    let offers: [Offers]
    
    enum CodingKeys: String, CodingKey {
        case offers
    }
}

struct Offers: Codable {
    let com: String?
    let img: String?
    let lib: String?
    let dateDebut: String?
    let dateFin: String?
    let id: Int
    let max: Int
    
    enum CodingKeys: String, CodingKey {
        case com, img, lib
        case dateDebut = "dtfrom"
        case dateFin = "dtto"
        case id = "idoffer"
        case max = "maxuse"
        
    }
}

// ------------------------ Traitement JSON : /client/offers/chosen

struct ListeOffreChoisi: Codable {
    let status: Int
    let data: DataOffersChosen
    
    enum CodingKeys: String, CodingKey {
        case status, data
    }
}

struct DataOffersChosen: Codable{
    let offers: [OffersChoice]
    
    enum CodingKeys: String, CodingKey {
        case offers
    }
}

struct OffersChoice: Codable {
    let com: String?
    let img: String?
    let lib: String?
    let dateDebut: String?
    let dateFin: String?
    let uses: Int
    let id: Int
    let max: Int
    
    enum CodingKeys: String, CodingKey {
        case com, img, lib, uses
        case dateDebut = "dtfrom"
        case dateFin = "dtto"
        case id = "idoffer"
        case max = "maxuse"
        
    }
}

// ------------------------ Traitement JSON : /client/info

struct TestConnection: Codable {
    let status: Int
    
    enum CodingKeys: String, CodingKey {
        case status
    }
}

struct CreateNewUser: Codable {
    let data: DataNewUser
    let status: Int
    
    enum CodingKeys: String, CodingKey {
        case data, status
    }
}

struct DataNewUser: Codable {
    let idcli: String?

    enum CodingKeys: String, CodingKey {
        case  idcli
    }
}

struct CompteUser: Codable {
    let data: DataUser
    let status: Int
    
    enum CodingKeys: String, CodingKey {
        case data, status
    }
}

struct DataUser: Codable {
    let head: HeadUser
    let idcli: String?
    let algoctrl: Int
    let compteurs: [CompteurUser]
    
    enum CodingKeys: String, CodingKey {
        case  idcli, algoctrl, head, compteurs
    }
}

struct HeadUser: Codable {
    let adr1: String?
    let pays: String?
    let cp: String?
    let gtu: Int
    let nom: String?
    let ville: String?
    let tel: String?
    let email: String?
    let status: String?
    let prenom: String?
    
    enum CodingKeys: String, CodingKey {
        case adr1, pays, cp, gtu, nom, ville, tel, email, status, prenom
    }
}

struct CompteurUser: Codable {
    let sp: Int
    let lib: String?
    let typ: Int
    let s0: Int
    let idcpt: Int
    let ref: String?
    let dp: String?
    
    enum CodingKeys: String, CodingKey {
        case sp, lib, typ, s0, idcpt, ref, dp
    }
}


struct ErrorConnexion: Codable {
    let errors: [ErrorDetail]
    let status: Int
    
    enum CodingKeys: String, CodingKey {
        case errors, status
    }
}

struct ErrorDetail: Codable {
    let code: Int
    
    enum CodingKeys: String, CodingKey {
        case code
    }
}


// ------------------------ Traitement JSON : "ÇÀ M'INTÉRESSE !!!"

struct SondageArticle: Codable {
    let list: [ListSondage]
    let lib: String?
    
    enum CodingKeys: String, CodingKey {
        case list, lib
    }
}

struct ListSondage: Codable {
    let dateDebut: String?
    let dateFin: String?
    let id: Int
    let urlImg: String?
    let description: String?
    let remaining: String?
    let reduction: String?
    let count: String?
    let category: [CatSondage]
    
    
    enum CodingKeys: String, CodingKey {
        case id, urlImg, description, remaining, reduction, count, category
        case dateDebut = "dt_from"
        case dateFin = "dt_to"
    }
}

struct CatSondage: Codable {
    let id: Int
    let lib: String?
    
    enum CodingKeys: String, CodingKey {
        case id, lib
    }
}



// ------------------------ Traitement JSON : /data/stores


struct ListeMagasin: Codable {
    let data: [Magasin]
    let status: Int
    
    enum CodingKeys: String, CodingKey {
        case data, status
    }
}

struct Magasin: Codable {
    let adr1: String?
    let ville: String?
    let idens: Int
    let libens: String?
    let lib: String?
    let pays: String?
    let ip: String?
    let idm: Int
    let cp: String?
    
    enum CodingKeys: String, CodingKey {
        case adr1, ville, idens, libens, lib, pays, ip, idm, cp
    }
}
