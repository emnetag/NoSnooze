//
//  EditAlarmTableVC.swift
//  NoSnooze
//
//  Created by Sanjay Sagar on 12/2/15.
//  Copyright © 2015 emnetg. All rights reserved.
//

import UIKit
import DatePickerCell
import Firebase
import FirebaseUI

class EditAlarmTableVC: UITableViewController {

    @IBOutlet weak var minFriends: UITextField! //Save this 
    
    var cells: NSArray = []
    
    var alarmOptions = ["Label","Add friends to Alarm","Minimum # of Friends"]
    var alarmLabel = "Alarm"
    
    var currentUser: User!
    var alarmMembers: [String]!
    var alarmStruct: Alarm!
    
    let rootRef = Firebase(url: "https://nosnooze.firebaseio.com")

    @IBAction func unwindToEditAlarm(segue: UIStoryboardSegue) {
        self.tableView.reloadData()
    }
    
    @IBAction func saveButton(sender: UIBarButtonItem) {
        // Saves the date, time, friends, and alarm label
        print("Saving...")
        
        //Get tableCell Data
        let cells = tableView.visibleCells
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss Z"
        formatter.timeStyle = .NoStyle
        
        var alarmTime = NSDate()
        var cutoffTime = NSDate()
        
        for cell in cells {
            if cell.isKindOfClass(DatePickerCell) {
                print("Found a datepicker")
                let dateCell = cell as! DatePickerCell
                if dateCell.leftLabel.text == "Time" {
                    alarmTime = dateCell.datePicker.date
                } else if dateCell.leftLabel.text == "Cutoff Snooze" {
                    cutoffTime = dateCell.datePicker.date
                }
            } else if cell.isKindOfClass(UITableViewCell) {
                print("Found a table cell")
                if cell.textLabel!.text! == "Label" {
                    self.alarmLabel = cell.detailTextLabel!.text!
                }
            }
        }
        
        var numFriends = 0
        
        if minFriends.text != nil {
            numFriends = NSNumberFormatter().numberFromString(minFriends.text!)!.integerValue
        }
        
        if cutoffTime.timeIntervalSince1970 > alarmTime.timeIntervalSince1970 {
            
            print("Saving Alarm...")
            
            var newAlarm = Alarm(alarmTime: alarmTime, userID: self.currentUser.uid, name: self.alarmLabel, cutoffTime: cutoffTime, members: alarmMembers, minFriends: numFriends)
            
            if newAlarm.storageFormat == false {
                newAlarm.toStorageFormat()
            }
            
            //Saves new alarm
            let userRef = Firebase(url: "https://nosnooze.firebaseio.com/users").childByAppendingPath(currentUser.uid!)
            
            let newAlarmRef = userRef.childByAppendingPath("alarms").childByAutoId()
            
            //New alarm saved to firebaseio.com/users/userID/alarms/autoID
            
            newAlarmRef.setValue(newAlarm.toAnyObject())

            let alarmKey = newAlarmRef.key!
            print("Alarm Key = \(alarmKey)")
            
            //Sends invites to new alarm if there are any
            sendInvites(newAlarm.members!, alarmID: alarmKey)
            
        } else {
            
            print("Cutoff Time must be after the alarm time")
            
        }
        
    }
    
    func sendInvites(members: [String], alarmID: String) {
        let invitesRef = Firebase(url: "https://nosnooze.firebaseio.com/invites")
        members.forEach { (userID) -> () in
            let currentInvite = invitesRef.childByAppendingPath(userID).childByAutoId()
            currentInvite.updateChildValues([
                "alarmID": alarmID,
                "userID": userID,
                "inviteID": currentInvite.key,
                "participating": false
            ])
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.rootRef.observeAuthEventWithBlock { (authData) -> Void in
            if authData != nil {
                self.currentUser = User(authData: authData)
            } else {
                print("No one is home")
            }
        }
    }
    
    override func viewDidLoad() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        // The DatePickerCell.
        let datePickerCell1 = DatePickerCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        datePickerCell1.leftLabel.text = "Time"
        let datePickerCell2 = DatePickerCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        datePickerCell2.leftLabel.text = "Cutoff Snooze"
        // Cells is a 2D array containing sections and rows.
        cells = [[datePickerCell1, datePickerCell2]]
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // Get the correct height if the cell is a DatePickerCell.
        if(indexPath.row < 2) { // First two needs to be formatted as DatePickerCells
            let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
            if (cell.isKindOfClass(DatePickerCell)) {
                return (cell as! DatePickerCell).datePickerHeight()
            }
        }
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Deselect automatically if the cell is a DatePickerCell.
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        if (cell.isKindOfClass(DatePickerCell)) {
            let datePickerTableViewCell = cell as! DatePickerCell
            datePickerTableViewCell.selectedInTableView(tableView)
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cells.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count + 2
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        /*
            if(indexPath.row <= 1) {
                return cells[indexPath.section][indexPath.row] as! UITableViewCell
        }*/
        
        var cell : UITableViewCell
        
        if(indexPath.row <= 1) {
        
            cell = cells[indexPath.section][indexPath.row] as! UITableViewCell
        
        } else if (indexPath.row == 2) {
            // Can create cell models here
            
            // Description -> goes to popup text box?, Add Friends -> goes to new VC, (Optional) Repeatable -> Is a (on/off) button
            
            cell = tableView.dequeueReusableCellWithIdentifier("EditLabelCell", forIndexPath: indexPath)
            
            cell.textLabel?.text = alarmOptions[indexPath.row - 2]
            
            cell.detailTextLabel?.text = alarmLabel
            
        } else {
            
            cell = tableView.dequeueReusableCellWithIdentifier("AddFriendCell", forIndexPath: indexPath)
            
            cell.textLabel?.text = alarmOptions[indexPath.row - 2]
        }
        
        return cell
    }
    
    /*override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("AlarmCell", forIndexPath: indexPath)
    //let image : UIImage = UIImage(named: "Question_Flat.png")! <- maybe use a clock image
    cell.imageView!.image = image // need image for each quiz
    cell.textLabel?.text = subjects[indexPath.row]
    cell.detailTextLabel!.text = descriptions[indexPath.row] // description goes here
    
    return cell
    }
    */
    
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
        if segue.identifier == "ShowAlarmLabel" {
            let destinationVC = segue.destinationViewController as! LabelAlarmVC
            destinationVC.text = alarmLabel;
        }
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem

    }
    

}
