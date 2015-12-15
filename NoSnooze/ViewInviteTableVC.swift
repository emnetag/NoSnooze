//
//  ViewInviteTableVC.swift
//  NoSnooze
//
//  Created by Sanjay Sagar on 12/14/15.
//  Copyright © 2015 emnetg. All rights reserved.
//

import UIKit
import Firebase

class ViewInviteTableVC: UITableViewController {
    
    var rawAlarm : Alarm!
    var alarm : Alarm!
    var alarmContent : [String] = []
    var rootRef : Firebase!
    var usersRef: Firebase!
    var alarmsRef: Firebase!
    var currentUser: User!
    var myAlarmsRef: Firebase!
    var myUserRef: Firebase!
    var invitesRef: Firebase!

    @IBAction func buttonPress(sender: UIButton) {
        rootRef.observeAuthEventWithBlock { (authData) -> Void in
            if sender.titleLabel?.text == "Accept" {
                self.currentUser = User(authData: authData)
                self.myUserRef = Firebase(url: "https://nosnooze.firebaseio.com/users/\(authData.uid!)")
                //let participatingRef = self.invitesRef.childByAppendingPath(self.rawAlarm.addedByUser).childByAppendingPath("participating")
                //participatingRef.setValue(true as AnyObject)
                var myInvitesRef : Firebase!
                myInvitesRef = self.invitesRef.childByAppendingPath(authData.uid!).childByAppendingPath(self.alarm.key)
                myInvitesRef.observeSingleEventOfType(.Value, withBlock: { inviteSnap in
                    let a = myInvitesRef.childByAppendingPath("participating")
                    a.setValue(true)
                    //inviteSnap.setValue(true, forKeyPath: )
                })
                let newAlarmRef = self.myUserRef.childByAppendingPath("alarms").childByAppendingPath(self.rawAlarm.key)
                newAlarmRef.setValue(self.rawAlarm.toAnyObject())
                //let alarmKey = newAlarmRef.key!
                sender.enabled = false
                sender.backgroundColor = UIColor.grayColor()
            }
        }
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usersRef = Firebase(url: "https://nosnooze.firebaseio.com/users")
        self.alarmsRef = Firebase(url: "https://nosnooze.firebaseio.com/alarms")
        self.rootRef = Firebase(url: "https://nosnooze.firebaseio.com")
        self.invitesRef = Firebase(url: "https://nosnooze.firebaseio.com/invites")
        self.rawAlarm = self.alarm
        alarm.toDisplayFormat()
        //print(alarm)
        rootRef.observeAuthEventWithBlock { (authData) -> Void in
            if authData != nil {
                self.alarmContent.append("Name: \(self.alarm.name)")
                self.alarmContent.append("Alarm: \(self.alarm.alarmString)")
                self.alarmContent.append("Snooze Time: \(self.alarm.cutoffString)")
                self.alarmContent.append("Min # of Friends: \(self.alarm.minFriends)")
                
                self.tableView.reloadData()
                
                var myInvitesRef : Firebase!
                myInvitesRef = self.invitesRef.childByAppendingPath(authData.uid!).childByAppendingPath(self.alarm.key)
                myInvitesRef.observeSingleEventOfType(.Value, withBlock: { inviteSnap in
                    print(inviteSnap.value["participating"] as! Bool)
                    if (inviteSnap.value["participating"] as! Bool) == false {
                        self.alarmContent.append("Join Alarm?")
                    } else {
                        self.alarmContent.append("Currently Participating!")
                    }
                    self.tableView.reloadData()
                })
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return alarmContent.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if alarmContent[indexPath.row] == "Join Alarm?" {
            let cell = tableView.dequeueReusableCellWithIdentifier("ParticipateCell", forIndexPath: indexPath)
            cell.textLabel?.text = alarmContent[indexPath.row]
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("ViewAlarmCell", forIndexPath: indexPath)
        cell.textLabel?.text = alarmContent[indexPath.row]
        
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
