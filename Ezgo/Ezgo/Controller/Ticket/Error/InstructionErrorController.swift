//
//  InstructionErrorController.swift
//  Ezgo
//
//  Created by Puagnol John on 19/12/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit

class InstructionErrorController: UIViewController {

    @IBOutlet weak var btnSendServer: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSendServer.arrondissementBouton()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func sendServer(_ sender: UIButton) {
    }
    
}
