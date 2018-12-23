//
//  RootController.swift
//  Ezgo
//
//  Created by Puagnol John on 14/12/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class RootController: MenuContainerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Transition
        
        transitionOptions = TransitionOptions(duration: 0.4, visibleContentWidth: 50)
        
        // MenuController
        if let menu = getInitial(string: "Menu") as? MenuViewController {
            menuViewController = menu
        }
        
        // Contenu
        
        contentViewControllers = [
            getInitial(string: "Client"),
            getInitial(string: "Catalogue"),
            getInitial(string: "Settings"),
            getInitial(string: "Main")
        ]
        
        // selectionner le 1er du contenu comme visible au départ :
        
        if contentViewControllers.count > 0 {
            selectContentViewController(contentViewControllers.last!)
        }

    }
    
    func getInitial(string: String) -> UIViewController {
        let storyboard = UIStoryboard(name: string, bundle: nil)
        return storyboard.instantiateInitialViewController() ?? UIViewController()
    }

}
