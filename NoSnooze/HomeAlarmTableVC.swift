//
//  HomeAlarmTableVC.swift
//  NoSnooze
//
//  Created by Sanjay Sagar on 12/2/15.
//  Copyright © 2015 emnetg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class HomeAlarmTableVC: UITableViewController {
    
    var alarms : [Alarm] = []
    var currentUser: User!
    
    let rootRef = Firebase(url: "https://nosnooze.firebaseio.com/")
    let alarmRef = Firebase(url: "https://nosnooze.firebaseio.com/alarms")
    
    let inviteRef = Firebase(url: "https://nosnooze.firebaseio.com/invites")
    
    
    //let formatter = NSDateFormatter()
    //formatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss Z"
    //formatter.dateFromString("")
    //retrieve data from firebase
    //add to array of tableview cells
    
    @IBAction func unwindToAlarmHome(segue: UIStoryboardSegue) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        self.inviteRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            print("New invite added...")
            
            
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.rootRef.observeAuthEventWithBlock { (authData) -> Void in
            if authData != nil {
                self.currentUser = User(authData: authData)
                
                self.alarmRef.queryOrderedByChild("addedByUser")
                    .queryEqualToValue(self.currentUser.uid)
                    .observeEventType(.Value, withBlock: { snapshot in
                        var newAlarms = [Alarm]()
                    
                        for item in snapshot.children {
                            let alarmUnit = Alarm(snapshot: item as! FDataSnapshot)
                            newAlarms.append(alarmUnit)
                        }
                    
                        self.alarms = newAlarms
                        self.tableView.reloadData()
                    })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.alarms.count
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            self.rootRef.observeAuthEventWithBlock { (authData) -> Void in
                if authData != nil {
                    self.currentUser = User(authData: authData)
                    
                    self.alarmRef.queryOrderedByChild("addedByUser")
                        .queryEqualToValue(self.currentUser.uid)
                        .observeEventType(.Value, withBlock: { snapshot in
                            var newAlarms = [Alarm]()
                            
                            for item in snapshot.children {
                                let alarmUnit = Alarm(snapshot: item as! FDataSnapshot)
                                newAlarms.append(alarmUnit)
                            }
                            
                            self.alarms = newAlarms
                            self.tableView.reloadData()
                        })
                }
            }
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlarmCell", forIndexPath: indexPath) as! AlarmTableViewCell
        
        
        //format cell here
        var currentAlarm = self.alarms[indexPath.row]
        currentAlarm.toDisplayFormat()
        cell.AlarmText.text = "\(currentAlarm.alarmString)"
        cell.CutoffTime.text = "Snooze Time: \(currentAlarm.cutoffString)"
        return cell
    }
}