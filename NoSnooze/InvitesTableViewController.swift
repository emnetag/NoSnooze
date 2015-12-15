//
//  InvitesTableViewController.swift
//  NoSnooze
//
//  Created by user on 12/14/15.
//  Copyright © 2015 emnetg. All rights reserved.
//

import UIKit
import Firebase

class InvitesTableViewController: UITableViewController {
    var invites: [Alarm] = []
    var rawInvites : [Alarm] = []
    var rootRef: Firebase!
    
    var invitesRef: Firebase!
    var myInvitesRef: Firebase!
    var alarmsRef: Firebase!
    
    var currentUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Invites view loaded")
        self.rootRef = Firebase(url: "https://nosnooze.firebaseio.com")
        self.alarmsRef = Firebase(url: "https://nosnooze.firebaseio.com/alarms")
        self.invitesRef = Firebase(url: "https://nosnooze.firebaseio.com/invites")
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        print("Invites view will appear")
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        rootRef.observeAuthEventWithBlock { (authData) -> Void in
            if authData != nil {
                self.invitesRef.childByAppendingPath(authData.uid!).observeEventType(.Value, withBlock: {inviteSnap in
                    if inviteSnap.hasChildren() {
                        print("has children")
                        for item in inviteSnap.children {
                            let thing = item as! FDataSnapshot
                            let myAlarmID = thing.value["alarmID"] as! String
                            print(myAlarmID)
                            self.alarmsRef.childByAppendingPath(myAlarmID).observeSingleEventOfType(.Value, withBlock: { alarmSnap in
                                let alarm = Alarm(snapshot: alarmSnap)
                                self.invites.append(alarm)
                                self.rawInvites.append(alarm)
                                print(self.invites.count)
                                self.tableView.reloadData()
                            })
                        }
                    }
                })
            } else {
                print("User is not logged in")
            }
        }
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        rootRef.removeAllObservers()
        invitesRef.removeAllObservers()
        invites = []
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
        return self.invites.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("alarmInviteCell", forIndexPath: indexPath) as! InviteTableViewCell
        
        var currentInvite = self.invites[indexPath.row]
        currentInvite.toDisplayFormat()
        
        cell.inviteText!.text! = "\(currentInvite.alarmString!)"
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return trues
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destinationVC = segue.destinationViewController as! ViewInviteTableVC
        let index = tableView.indexPathForSelectedRow!
        destinationVC.alarm = rawInvites[index.row]
    }
    

}
