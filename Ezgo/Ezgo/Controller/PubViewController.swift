//
//  PubViewController.swift
//  Ezgo
//
//  Created by Puagnol John on 14/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit

class PubViewController: UIViewController {

    @IBOutlet weak var zonePub: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        zonePub.loadGif(name: "oasis")
    }
}
