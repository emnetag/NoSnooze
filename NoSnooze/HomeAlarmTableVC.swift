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
    
    override func viewDidAppear(animated: Bool) {
        
        
        
    }
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
                    })
                
                
            } else {
                print("No one is home.")
            }
        }
        /*alarmRef.observeEventType(.Value, withBlock: { snapshot in
        
        for item in snapshot.children {
        let childSnapshot = snapshot.childSnapshotForPath(item.key)
        if childSnapshot.value["addedByUser"] as! String == self.currentUser.uid {
        print (childSnapshot.value["alarmTime"] as! String)
        }
        //let someValue = childSnapshot.value["addedByUser"] as! String
        //print(someValue)
        }
        }, withCancelBlock: { error in
        print(error.description)
        })*/
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    /*override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }*/
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //print(self.alarmTimes.count)
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
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
        // Delete the row from the data source
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
