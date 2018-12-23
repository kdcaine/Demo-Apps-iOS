//
//  ErrorPopupMsgController.swift
//  Ezgo
//
//  Created by Puagnol John on 19/12/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit

class ErrorPopupMsgController: UIViewController {

    @IBOutlet weak var btnRetry: UIButton!
    @IBOutlet weak var btnUrgence: UIButton!
    @IBOutlet weak var msgShow: UILabel!
    @IBOutlet weak var zonePopup: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        zonePopup.arrondissementZone(addShadow: true)
        btnRetry.arrondissementBouton()
        btnUrgence.arrondissementBouton()
    }
    
    @IBAction func retry(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
   
}
