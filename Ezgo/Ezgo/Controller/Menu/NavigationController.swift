//
//  NavigationController.swift
//  Ezgo
//
//  Created by Puagnol John on 13/12/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class NavigationController: UIViewController, SideMenuItemContent {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func actionBtnClient(_ sender: Any) {
        changementView(cible : "storyClient", storyboard: "Client")
    }
    
    
    @IBAction func actionBtnCatalogue(_ sender: Any) {
        changementView(cible : "storyCat", storyboard: "Catalogue")
    }
    
    @IBAction func actionBtnTicket(_ sender: Any) {
//        changementView(cible : "storyTicket",storyboard: "Tickets")
    }
    
    @IBAction func actionBtnPromotions(_ sender: Any) {
//        changementView(cible : "storyPromo", storyboard: "Promo")
    }
    
    func changementView(cible : String, storyboard: String){
        let storyBoard : UIStoryboard = UIStoryboard(name: storyboard, bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: cible)
        self.present(nextViewController, animated: true, completion:nil)
    }

}
