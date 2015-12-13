//
//  FriendsTableViewController.swift
//  NoSnooze
//
//  Created by user on 12/10/15.
//  Copyright © 2015 emnetg. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Foundation
import FirebaseUI

class FriendsTableViewController: UITableViewController {

    var accessToken: String!
    var currentUserID: String!
    
    var friends = [NSDictionary]()
    
    var friendsCount: Int!
    
    var currentAlarm: Alarm!
    
    var tempMembers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        let params = ["fields": "id, friends"]
        
        self.accessToken = FBSDKAccessToken.currentAccessToken().tokenString
        
        if (self.accessToken != nil) {
            
            let request = FBSDKGraphRequest.init(graphPath: "me", parameters: params, tokenString: self.accessToken, version: "v2.5", HTTPMethod: "GET")
            request.startWithCompletionHandler({ (connection, facebookResult, error) -> Void in
                
                if ((error) != nil) {
                    print("Error: \(error)")
                } else {
                    let result = facebookResult as? NSDictionary
                    
                    if let friends = result?["friends"]!{
                        
                        let friendsDict = friends as! NSDictionary
                        let data = friendsDict["data"] as! NSArray
                        
                        data.forEach({ (friendObj) -> () in
                            let friend = friendObj as? NSDictionary
                            self.friends.append(friend!)
                        })
                        
                        self.tableView.reloadData()
                        print("I have \(self.friends.count) friends")
                    }
                }
            })
        }
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
        return self.friends.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FacebookFriendCell", forIndexPath: indexPath)
        
        let name = self.friends[indexPath.row]["name"] as? String
        
        cell.textLabel?.text = name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let friendCell = tableView.cellForRowAtIndexPath(indexPath)
        let idStr = "facebook:\(self.friends[indexPath.row]["id"] as! String)"
        
        if friendCell?.accessoryType == .Checkmark {
            friendCell?.accessoryType = .None
            self.tempMembers.removeAtIndex(indexPath.row)
        } else {
            friendCell?.accessoryType = .Checkmark
            self.tempMembers.append(idStr)
        }
        print("I have \(tempMembers.count) temp members")
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC = segue.destinationViewController as! EditAlarmTableVC
        destinationVC.alarmMembers = tempMembers
    }

}
