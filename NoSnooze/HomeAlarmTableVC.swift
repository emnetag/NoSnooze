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
    var alarmRef: Firebase!
    var invitesRef: Firebase!
    var usersRef: Firebase!
    
    var alarmHandle: UInt!
    var invitesHandle: UInt!
    
    @IBAction func unwindToAlarmHome(segue: UIStoryboardSegue) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rootRef = Firebase(url: "https://nosnooze.firebaseio.com/")
        self.alarmRef = Firebase(url: "https://nosnooze.firebaseio.com/alarms")

        self.rootRef.observeAuthEventWithBlock { (authData) -> Void in
            if authData != nil {
                self.currentUser = User(authData: authData)
                self.usersRef = Firebase(url: "https://nosnooze.firebaseio.com/users")
                self.invitesRef = Firebase(url: "https://nosnooze.firebaseio.com/invites/").childByAppendingPath(authData.uid!)
                print("Invites ref key is \(self.invitesRef.key)")
            } else {
                print("Auth Data is nil")
            }
        }
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        alarmHandle = self.usersRef.childByAppendingPath(self.currentUser.uid).childByAppendingPath("alarms")
            .observeEventType(.Value, withBlock: { snapshot in
                
                var newAlarms = [Alarm]()
                    
                for item in snapshot.children {
                    let alarmUnit = Alarm(snapshot: item as! FDataSnapshot)
                    newAlarms.append(alarmUnit)
                }
                self.alarms = newAlarms
                self.tableView.reloadData()
        })
        
        var invite: Invite?
        invitesHandle = self.invitesRef?.observeEventType(.ChildAdded, withBlock: { inviteSnap in
            
            invite = Invite(snapshot: inviteSnap)
            print("I have been invited to \(invite!.alarmID!)")
            
            let tempRef = self.alarmRef.childByAppendingPath(invite!.alarmID!)
            
            tempRef.observeSingleEventOfType(.Value, withBlock: {alarmSnap in
                let alarm = Alarm(snapshot: alarmSnap)
                print(alarm.addedByUser!)
                
                //show Alert Controller
                self.showAlertForAlarm(alarm, alarmID: invite!.alarmID!, inviteID: invite!.inviteID)
                
            })
        })
    }
    
    func showAlertForAlarm(var alarm: Alarm, alarmID: String, inviteID: String) {
        print("Showing alert...")
        
        self.usersRef.childByAppendingPath(alarm.addedByUser!).observeSingleEventOfType(.Value, withBlock: {userSnap in
            let userName = userSnap.value["displayName"] as! String
            
            let inviteMessage = "\(userName) invited you to their alarm. Would you like to join?"
            
            let alertController = UIAlertController(title: "Alarm Invitation", message: inviteMessage, preferredStyle: .Alert)
            
            alertController.addAction(UIAlertAction(title: "Nope", style: .Cancel, handler: {(alert: UIAlertAction!) in
                // User cancelled alarm
                print("Invite was declined")
                self.invitesRef.childByAppendingPath(inviteID).removeValue()
            }))
            
            alertController.addAction(UIAlertAction(title: "Okay", style: .Default, handler: {(alert: UIAlertAction!) in
                print("Invite was acccepted")
                // User accepts alarm
                
                // Alarm is saved to /users/userid/alarms/alarmid
                self.usersRef
                    .childByAppendingPath(self.currentUser.uid!)
                    .childByAppendingPath("alarms")
                    .childByAppendingPath(alarmID).setValue(alarm.toAnyObject())
                
                //Removte invite for user
                self.invitesRef.childByAppendingPath(inviteID).removeValue()
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        })

    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(animated)
        alarmRef.removeObserverWithHandle(alarmHandle)
        invitesRef.removeObserverWithHandle(invitesHandle)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.d
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
        
        //format cell here
        var currentAlarm = self.alarms[indexPath.row]
        currentAlarm.toDisplayFormat()
        cell.AlarmText.text = "\(currentAlarm.alarmString)"
        cell.CutoffTime.text = "Snooze Time: \(currentAlarm.cutoffString)"
        return cell
    }
}