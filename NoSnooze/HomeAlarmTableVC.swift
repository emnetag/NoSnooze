//
//  HomeAlarmTableVC.swift
//  NoSnooze
//
//  Created by Sanjay Sagar on 12/2/15.
//  Copyright © 2015 emnetg. All rights reserved.
//

import UIKit
import Firebase

struct AlarmUnit {
    var date : String
    var time : String
    var title: String
    var cutoffTime : String
}

class HomeAlarmTableVC: UITableViewController {
    
    var alarms : [AlarmUnit] = []
    var currentUser: User!
    var titles : [String] = []
    var alarmTimes : [String] = []
    let rootRef = Firebase(url: "https://nosnooze.firebaseio.com/")
    let alarmRef = Firebase(url: "https://nosnooze.firebaseio.com/alarms")
    
    
    //let formatter = NSDateFormatter()
    //formatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss Z"
    //formatter.dateFromString("")
    //retrieve data from firebase
    //add to array of tableview cells
    @IBAction func unwindToAlarmHome(segue: UIStoryboardSegue) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss Z"
        self.rootRef.observeAuthEventWithBlock { (authData) -> Void in
            if authData != nil {
                self.currentUser = User(authData: authData)
                print("Current user is \(self.currentUser.displayName!)")
                
                self.alarmRef.queryOrderedByChild("addedByUser").queryEqualToValue(self.currentUser.uid)
                    .observeSingleEventOfType(.ChildAdded, withBlock: { snapshot in
                        //retrieves alarm times
                        //print(snapshot.value["alarmTime"] as! String)
                        
                        let title = snapshot.value["name"] as! String
                       
                        let dateString = snapshot.value["alarmTime"] as! String
                        
                        let cutoffTimeDate = dateFormatter.dateFromString(snapshot.value["cutoffTime"] as! String)
                        
                        let date = dateFormatter.dateFromString(dateString)
                        dateFormatter.dateFormat = "EEE, MMM d"
                        
                        let dateShort = dateFormatter.stringFromDate(date!)
                        
                        dateFormatter.dateFormat = "HH:mm a"
                        
                        dateFormatter.timeStyle = .ShortStyle
                        
                        let time = dateFormatter.stringFromDate(date!)
                        
                        let cutoffTime = dateFormatter.stringFromDate(cutoffTimeDate!)
                        
                        //print(time)
                        //self.titles.append(title)
                        //self.alarmTimes.append(time) // Gets time of each alarm in AM/PM format
                        //Need to double check about if should leave this chunk on viewdidload
                       
                        self.alarms += [AlarmUnit(date: dateShort, time: time, title: title, cutoffTime: cutoffTime)]
                        self.tableView.reloadData()
                        print("I have \(self.alarms.count) alarms on me.")
                    })
                
            } else {
                print("No one is home.")
            }
        }
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.alarms.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlarmCell", forIndexPath: indexPath) as! AlarmTableViewCell
        
        //let image : UIImage = UIImage(named: "Question_Flat.png")! <- maybe use a clock image
        //cell.imageView!.image = image // need image for each quiz
        
        cell.AlarmText.text = "\(self.alarms[indexPath.row].time) on \(self.alarms[indexPath.row].date)"
        cell.CutoffTime.text = "Snooze Time: \(self.alarms[indexPath.row].cutoffTime)"
        
        return cell
    }
}