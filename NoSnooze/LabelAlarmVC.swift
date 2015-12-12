//
//  LabelAlarmVC.swift
//  NoSnooze
//
//  Created by Sanjay Sagar on 12/3/15.
//  Copyright © 2015 emnetg. All rights reserved.
//

import UIKit

class LabelAlarmVC: UIViewController {

    @IBOutlet weak var alarmLabel: UITextField!
    var text : String = ""
    @IBOutlet weak var save: UIBarButtonItem!
    
    @IBAction func saveButton(sender: UIBarButtonItem) {
        text = alarmLabel.text!;
        save.enabled = false;
    }
    
    // Double check the save enable on text change
    @IBAction func textField(sender: UITextField) {
         save.enabled = true;
    }
    override func viewDidAppear(animated: Bool) {
        alarmLabel.becomeFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        save.enabled = false;
        alarmLabel.text = text;
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destinationVC = segue.destinationViewController as! EditAlarmTableVC
        destinationVC.alarmLabel = alarmLabel.text!
    }
    

}
