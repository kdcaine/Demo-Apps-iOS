//
//  MenuController.swift
//  Ezgo
//
//  Created by Puagnol John on 14/12/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class MenuController: MenuViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var items = ["Information Client", "Catalogue", "Parametres", "Déconnexion"]
    var itemsIcon = ["m_user", "m_cat", "m_settings", "m_logout"]

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .darkGray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.setup()
    }
}

extension MenuController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuContainerViewController?.contentViewControllers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MenuSCell") as? MenuSlideCell {
            cell.setup(items[indexPath.row], nomImg: itemsIcon[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let main = menuContainerViewController {
            main.selectContentViewController(main.contentViewControllers[indexPath.row])
            main.hideSideMenu()
        }
    }
}
