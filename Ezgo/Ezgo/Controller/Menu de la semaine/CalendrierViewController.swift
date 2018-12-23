//
//  CalendrierViewController.swift
//  Ezgo
//
//  Created by Puagnol John on 15/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit
import JTAppleCalendar
import CoreData
import InteractiveSideMenu

class CalendrierViewController: UIViewController, SideMenuItemContent {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    
    let outsideMonthColor = UIColor(colorWithHexValue: 0x584a66)
    let monthColor = UIColor.white
    let selectedMonthColor = UIColor(colorWithHexValue: 0x3a294b)
    let currentDateSelectedViewColor = UIColor(colorWithHexValue: 0x4e3f5d)
    
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = "yyyy MM dd"
        return dateFormatter
    }()
    
    let todaysDate = Date()
    
    var eventsFromTheServer: [String:String] = [:]
    
    var redirectionActive = false
    
    var dayToSend = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // recupere les dates avec un données
        let serverObjects = self.getServerEvents()
        for (date, event) in serverObjects {
            print(event)
            let stringDate = self.formatter.string(from: date)
            self.eventsFromTheServer[stringDate] = event
        }
        
        self.calendarView.reloadData()
        
        
        
        // Mettre le calendrier pour ce mois et la date du jour:
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.selectDates([ Date() ])
        
        setupCalendarView()
    }
    
    
    func setupCalendarView(){
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        // load month and year
        calendarView.visibleDates { (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo){
        guard let date = visibleDates.monthDates.first?.date else { return }
        
        self.formatter.dateFormat = "yyyy"
        self.year.text = self.formatter.string(from: date)
        
        self.formatter.dateFormat = "MMMM"
        self.month.text = self.formatter.string(from: date).uppercased()
    }
    
    
    
    func configureCell(cell: JTAppleCell?, cellState: CellState){
        guard let myCustomCell = cell as? CellDate else {return}
        
        handleCelltextColor(cell: myCustomCell, cellState: cellState)
        handleCellVisibility(cell: myCustomCell, cellState: cellState)
        handleCellSelected(cell: myCustomCell, cellState: cellState)
        handleCellEvents(cell: myCustomCell, cellState: cellState)
    }
    
    
    func handleCelltextColor(cell: CellDate, cellState: CellState) {
        
        formatter.dateFormat = "yyyy MM dd"
        let todaysDateString = formatter.string(from: todaysDate)
        let monthDateString = formatter.string(from: cellState.date)
        
        if todaysDateString == monthDateString {
            cell.dateLabel.textColor = UIColor.blue
        } else {
            cell.dateLabel.textColor = cellState.isSelected ? UIColor.red : UIColor.black
        }
    }
    
    func handleCellVisibility(cell: CellDate, cellState: CellState) {
        cell.isHidden = cellState.dateBelongsTo == .thisMonth ? false : true
    }
    
    func handleCellSelected(cell: CellDate, cellState: CellState) {
        cell.selectedView.isHidden = cellState.isSelected ? false : true
    }
    
    func handleCellEvents(cell: CellDate, cellState: CellState) {
        cell.eventDotView.isHidden = !eventsFromTheServer.contains { $0.key == formatter.string(from: cellState.date) }
    }
    
    @IBAction func resetCalendar(_ sender: UIButton) {
        redirectionActive = false
        calendarView.scrollToDate(Date(), animateScroll: true)
        calendarView.selectDates([ Date() ])
    }
    
    @IBAction func btnGestionMenu(_ sender: UIButton) {
        //changementView(cible: "menuGestionZone")
    }
    
    func changementView(cible : String){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Calendrier", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: cible)
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func showMenu(_ sender: Any) {
        showSideMenu()
    }
    
    
    //
    
}

extension CalendrierViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        let startDate = formatter.date(from: "2018 01 01")!
        let endDate = formatter.date(from: "2030 01 01")!
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
}

extension CalendrierViewController: JTAppleCalendarViewDelegate{
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let mycell = cell as! CellDate
        mycell.dateLabel.text = cellState.text
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let mycell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCellDate", for: indexPath) as! CellDate
        
        mycell.dateLabel.text = cellState.text
        configureCell(cell: mycell, cellState: cellState)
        return mycell
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
        
        formatter.dateFormat = "dd-MM-yyyy"
        let dateCellule = formatter.string(from: cellState.date)
        dayToSend = dateCellule
        
        if redirectionActive {
            //performSegue(withIdentifier: "segueDateSend", sender: self)
        }
        
        redirectionActive = true
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
    
}

extension CalendrierViewController {
    func getServerEvents() -> [Date:String] {
        
        var monCalendrierComplet : [Date:String] = [:]
        
        let requete: NSFetchRequest<CalendarFood> = CalendarFood.fetchRequest()
        
        do {
            let calendarRepas = try contexte.fetch(requete)
            
            if calendarRepas.count > 0 {
                
                for dayRepas in calendarRepas{
                    
                    let nom = dayRepas.nom
                    let date = dayRepas.date
                    
//                    print("donnee du jour : ")
//                    print(nom)
//                    print(date)
                    
                    // Convertir string en date
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    let goodDate = dateFormatter.date(from: date!)
                    // Convertir la date dans le bonne ordre
                    dateFormatter.dateFormat = "yyyy MM dd"
                    let newDate = dateFormatter.string(from: goodDate!)
                    // Remettre le string en date
                    formatter.dateFormat = "yyyy MM dd"
                    let finalDate = formatter.date(from: newDate)
                    
                    monCalendrierComplet[finalDate!] = nom
                }
            }
            
        } catch {
            // en cas d'erreur si la donnée n'existe pas
            print(error.localizedDescription)
        }
        
        print("la liste complete : ")
        print(monCalendrierComplet)
        return monCalendrierComplet

    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "segueDateSend" {
//            let vc = segue.destination as! JourCalendrierController
//            vc.dayReceive = self.dayToSend
//        }
//
//    }
}
