//
//  ViewController.swift
//  Hinds_Justin_CE7
//
//  Created by Justin Hinds on 10/12/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class ViewController: UIViewController, EKCalendarChooserDelegate, EKEventEditViewDelegate {
    
    let eventStore = EKEventStore()
    var calendar : EKCalendar?
    
    
    @IBAction func deleteCalendar(_ sender: UIButton) {
        let caledarList = eventStore.calendars(for: .event)
        //print(caledarList)
        if caledarList.count > 0 {
        do{
             print("delete ativated")
            for calendars in caledarList{
                if calendars.allowsContentModifications == true || calendars.title != "Calendar"{
            try eventStore.removeCalendar(calendars, commit: true)
                }
            }
           // calendar = nil
            
        }catch{
            print(error)
        }
    }
    }
    
    @IBAction func calendarChooser(_ sender: UIButton) {
        let calendarList = eventStore.calendars(for: .event)
        print(calendarList)
        if calendarList.count > 3{
            
            let chooser = EKCalendarChooser(selectionStyle: .single, displayStyle: .allCalendars, entityType: .event, eventStore: eventStore)
            let nav = UINavigationController(rootViewController: chooser)
            chooser.showsDoneButton = true
            chooser.showsCancelButton = true
            chooser.delegate = self
            
            present(nav, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func clearAllEvents(_ sender: UIButton) {
        //start date for pred - for the begining of time
        let startDate = Date().addingTimeInterval((-60*60*24))
        //end date for pred current time
        let endDate = Date().addingTimeInterval((60*60*24))
        //searches eventstore for events within a range
        let pred = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        //array of events within range
        let predList = eventStore.events(matching: pred) as [EKEvent]
        // loop to remove events
        for event in predList{
            do{
                try  eventStore.remove(event, span: .futureEvents)
                
            }catch{
                print("UH OH: \(error)")
            }
        }

    }
    

 //
    @IBAction func newEvent(_ sender: UIButton) {
        let eventVC = EKEventEditViewController()
        eventVC.eventStore = eventStore
        eventVC.editViewDelegate = self
        present(eventVC, animated: true, completion: nil)
        
        //For notes
        //
        //        let event = EKEvent(eventStore: eventStore)
        //        event.startDate = Date()
        //        event.title = "New Event"
        //        event.endDate =  event.startDate.addingTimeInterval(10000)
        //        event.calendar = calendar
        //
        //        do{
        //            try eventStore.save(event, span: .thisEvent, commit: true)
        //        }catch{
        //            print(error)
        //        }
    }
    
    @IBAction func createCalendar(_ sender: AnyObject) {
        
        calendar = EKCalendar(for: .event, eventStore: eventStore)
        calendar?.title = "User Calendar"
        calendar?.cgColor = UIColor.blue.cgColor
        for source in eventStore.sources{
            if source.sourceType == EKSourceType.local{
                calendar?.source = source
                
                break
            }
        }
        
        do{
            try eventStore.saveCalendar(calendar!, commit: true)
        }catch{
            print(error)
        }
        
    }
    //delegate funcs for event view
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        dismiss(animated: true, completion: nil)
    }
    //    func eventEditViewControllerDefaultCalendar(forNewEvents controller: EKEventEditViewController) -> EKCalendar {
    //      return calendar
    //    }
    //delegate funcs for calendar chooser
    func calendarChooserDidCancel(_ calendarChooser: EKCalendarChooser) {
        dismiss(animated: true, completion: nil)
        
    }
    func calendarChooserDidFinish(_ calendarChooser: EKCalendarChooser) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let status = EKEventStore.authorizationStatus(for: .event)
        
        if status == .notDetermined{
            eventStore.requestAccess(to: .event, completion: { (granted, error) in
                if let error = error{
                    print(error)
                    return
                }
                
                if granted{
                    
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

