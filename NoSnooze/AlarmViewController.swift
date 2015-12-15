//
//  Active Alarm.swift
//  NoSnooze
//
//  Created by Vikram Thirumalai on 12/10/15.
//  Copyright © 2015 emnetg. All rights reserved.
//

import UIKit
import AVFoundation

class AlarmViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    @IBOutlet var alarmName: UILabel!
    @IBOutlet var snoozeButton: UIButton!
    @IBOutlet var readyUp: UIButton!
    var currAlarm : Alarm!
    override func viewDidLoad() {
        super.viewDidLoad()
        let audioFilePath = NSBundle.mainBundle().pathForResource("alarm", ofType: "mp3")
        alarmName.text = currAlarm.name
        if audioFilePath != nil {
            
            let audioFileUrl = NSURL.fileURLWithPath(audioFilePath!)
            
            audioPlayer = try! AVAudioPlayer(contentsOfURL: audioFileUrl)
            audioPlayer.play()
            
        }
        
    }
    
    @IBAction func snoozePressed(sender: AnyObject) {
        audioPlayer.stop()
    }
    @IBAction func readyPressed(sender: AnyObject) {
        audioPlayer.stop()
        let sb = UIStoryboard(name: "LandingPage", bundle: nil)
        let VC = sb.instantiateInitialViewController() as UIViewController!
        self.presentViewController(VC, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
