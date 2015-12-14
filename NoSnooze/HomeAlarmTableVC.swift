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
    
    var rootRef: Firebase!
    
    var alarmsRef: Firebase!
    
    var myAlarmsRef: Firebase!
    
    var myInvitesRef: Firebase!
    
    var usersRef: Firebase!
    
    var alarmHandle: UInt!
    
    var keys: [String]!
    
    //var timer:[(name: Alarm, value: NSTimer)] = []
    
    @IBAction func unwindToAlarmHome(segue: UIStoryboardSegue) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rootRef = Firebase(url: "https://nosnooze.firebaseio.com/")
        
        self.rootRef.observeAuthEventWithBlock { (authData) -> Void in
            if authData != nil {
                
                self.currentUser = User(authData: authData)
                
                //usersRef = /users
                self.usersRef = Firebase(url: "https://nosnooze.firebaseio.com/users")
                
                //alarmsRef = /alarms
                self.alarmsRef = Firebase(url: "https://nosnooze.firebaseio.com/alarms")
                
                //myAlarmsRef = /users/userID/alarms
                self.myAlarmsRef = self.usersRef.childByAppendingPath(authData.uid!).childByAppendingPath("alarms")
                
                //myInvitesRef = /invites/userID
                self.myInvitesRef = Firebase(url: "https://nosnooze.firebaseio.com/invites/").childByAppendingPath(authData.uid!)
            } else {
                print("Auth Data is nil")
            }
        }
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        alarmHandle = self.myAlarmsRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            let alarmKey = snapshot.key
            self.alarms = [Alarm]()
            self.alarmsRef.childByAppendingPath(alarmKey).observeSingleEventOfType(.Value, withBlock: {snapshot in
                let newAlarm = Alarm(snapshot: snapshot)
                self.alarms.append(newAlarm)
                self.tableView.reloadData()
            })
        })
        
        var invite: Invite?
        self.myInvitesRef.observeSingleEventOfType(.ChildAdded, withBlock: { inviteSnap in
            
            if inviteSnap.hasChildren() {
                
                invite = Invite(snapshot: inviteSnap)
                print("I have been invited to \(invite!.alarmID!)")
                
                let tempRef = self.alarmsRef.childByAppendingPath(invite!.alarmID!)
                
                tempRef.observeSingleEventOfType(.Value, withBlock: {alarmSnap in
                    
                    let alarm = Alarm(snapshot: alarmSnap)
                    print(alarm.addedByUser!)
                    
                    //show Alert Controller
                    self.showAlertForAlarm(alarm, alarmID: invite!.alarmID!, inviteID: invite!.inviteID!)
                    
                })
            } else {
                print("No invites for now")
            }
        })
    }
    
    func showAlertForAlarm(alarm: Alarm, alarmID: String, inviteID: String) {
        print("Showing alert...")
        
        self.usersRef.childByAppendingPath(alarm.addedByUser!).observeSingleEventOfType(.Value, withBlock: {userSnap in
            let userName = userSnap.value["displayName"] as! String
            
            let inviteMessage = "\(userName) invited you to their alarm. Would you like to join?"
            
            let alertController = UIAlertController(title: "Alarm Invitation", message: inviteMessage, preferredStyle: .Alert)
            
            alertController.addAction(UIAlertAction(title: "Nope", style: .Cancel, handler: {(alert: UIAlertAction!) in
                // User cancelled alarm
                print("Invite was declined")
                self.myInvitesRef.childByAppendingPath(inviteID).removeValue()
            }))
            
            alertController.addAction(UIAlertAction(title: "Okay", style: .Default, handler: {(alert: UIAlertAction!) in
                print("Invite was acccepted")
                // User accepts alarm
                
                // Alarm is saved to /users/userid/alarms/alarmid
                self.usersRef.childByAppendingPath(self.currentUser.uid!)
                    .childByAppendingPath("alarms")
                    .childByAppendingPath(alarmID).setValue(["\(alarmID)": true])
                
                //Removte invite for user
                self.myInvitesRef.childByAppendingPath(inviteID).removeValue()
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            // Delete the row from the data source
            
            alarms[indexPath.row].ref!.removeValue()
            
            alarms.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            
            tableView.reloadData()
        }
        // NSLog("Why hello: DIS HOW MANY ALARMS YOU GOT! \(alarms.count)")
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlarmCell", forIndexPath: indexPath) as! AlarmTableViewCell
        
        
        //format cell here
        var currentAlarm = self.alarms[indexPath.row]
        /*var s = NSTimer()
        timer.append(name: currentAlarm, value: currentAlarm.alarmTime.timeIntervalSinceNow)
        NSLog("HELLO 2 ALL \(self.alarms[0].dateFormatter.description)")
        NSLog("HELLO 3 ALL \(self.alarms[0].alarmTime.timeIntervalSinceNow)") */
        currentAlarm.toDisplayFormat()
        cell.AlarmText.text = "\(currentAlarm.alarmString)"
        cell.CutoffTime.text = "Snooze Time: \(currentAlarm.cutoffString)"
       // NSLog("Why hello: DIS HOW MANY ALARMS YOU GOT! \(alarms.count)")
        return cell
    }
}