//
//  ListeCourseController.swift
//  Ezgo
//
//  Created by Puagnol John on 15/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit
import CoreData

class ListeCourseController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var quitter: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var mesListes = [ListeList]()
    var listeDeListe = [ListeCourse]()
    
    let identifiantCell = "maListeCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        quitter.arrondissementBouton()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        fetchAllListeCourse()
    }
    
    
    func fetchAllListeCourse() {
        
        // requete pour cibler la données.
        let requete: NSFetchRequest<ListeCourse> = ListeCourse.fetchRequest()
        
        do {
            // réponse contenant les données du client :
            listeDeListe = try contexte.fetch(requete)
            mesListes =  [ListeList]()
            
            for list in listeDeListe{
                let nom = list.nom
                
                let titre_liste = ListeList(titre_liste: nom!)
                mesListes.append(titre_liste)
            }
            tableView.reloadData()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mesListes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let maListe = mesListes[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifiantCell) as?  ListeCell {
            cell.creerCell(maListe)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title:"Delete") { (action, view, completion) in
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.reloadData()
            completion(true)
        }
        action.image = #imageLiteral(resourceName: "miniTrash")
        action.backgroundColor = .red
        return action
        
    }
    
    @IBAction func addListe(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Tickets", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "popupChoix")
        nextViewController.modalTransitionStyle = .crossDissolve
        nextViewController.modalPresentationStyle = .overCurrentContext
        self.present(nextViewController, animated:true, completion:nil)
    }
    
}
