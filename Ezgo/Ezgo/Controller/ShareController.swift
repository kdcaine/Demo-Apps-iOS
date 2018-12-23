//
//  ShareController.swift
//  Ezgo
//
//  Created by Puagnol John on 14/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit

class ShareController: UIViewController {
    
    @IBOutlet weak var maPub: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        maPub.loadGif(name: "carrefour")
        
    }
}
