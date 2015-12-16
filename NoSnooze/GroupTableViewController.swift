//
//  GroupTableViewController.swift
//  NoSnooze
//
//  Created by Teddy Pappas on 12/14/15.
//  Copyright © 2015 emnetg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class GroupTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var groups = [Group]()
    
    var alarmsRef: Firebase!
    
    var usersRef: Firebase!
    
    @IBOutlet weak var groupChat: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print("lol")
        alarmsRef = Firebase(url: "https://nosnooze.firebaseio.com/alarms")
        usersRef = Firebase(url: "https://nosnooze.firebaseio.com/users")
        loadGroupChats()
        // print(self.groups)
        self.tableView.reloadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 1
        self.alarmsRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            
            if snapshot.hasChildren() {
                //                var things = [Group]()
                
                let thing = snapshot.value.objectForKey("name") as! String
                //print(thing)
                if snapshot.value.objectForKey("members") != nil {
                    let list = snapshot.value.objectForKey("members") as! [String]
                    //print(list)
                    let temp = Group(name: thing, members: list)
                    self.groups.append(temp)
                    //print(temp)
                    //self.groups = things
                    //print(self.groups)
                    self.tableView.reloadData()
                }
                
            }
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    func loadGroupChats() {
        //        print("2")
        //        self.alarmsRef.observeEventType(.ChildAdded, withBlock: { snapshot in
        //            //            print(snapshot.value.objectForKey("name"))
        //            //            print(snapshot.value.objectForKey("members"))
        //            //groups.append(Group)
        //            if snapshot.hasChildren() {
        //
        //                let thing = snapshot.value.objectForKey("name") as! String
        //                //print(thing)
        //                if snapshot.value.objectForKey("members") != nil {
        //                    let list = snapshot.value.objectForKey("members") as! [String]
        //                    //print(list)
        //                    let temp = Group(name: thing, members: list)
        //                    self.groups.append(temp)
        ////                    print(temp)
        //                }
        //
        //            }
        //        })
        
        //        let meal1 = Group(name: "Caprese Salad", members: ["John", "Josh"])
        //
        //        let meal2 = Group(name: "Chicken and Potatoes", members: ["John", "Josh"])
        //
        //        let meal3 = Group(name: "Pasta with Meatballs", members: ["John", "Josh"])
        //
        //        groups += [meal1, meal2, meal3]
        //
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
        
        return self.groups.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "GroupTableViewCell"
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! GroupTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        print(self.groups)
        
        let group = self.groups[indexPath.row].name!
        
        cell.chatName.text = group
        
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cell = sender as! GroupTableViewCell?
        
        groups.removeAll()
        
        let MessagesController = segue.destinationViewController as! MessagesViewController
                
        MessagesController.navigationItem.title = cell?.chatName.text
        MessagesController.members = ["facebook:10153291349701984", "facebook:10153696977173592"]
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}