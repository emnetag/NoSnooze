//
//  Active Alarm.swift
//  NoSnooze
//
//  Created by Vikram Thirumalai on 12/10/15.
//  Copyright © 2015 emnetg. All rights reserved.
//

import UIKit
import AVFoundation

class Active_Alarm: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    @IBOutlet var alarmName: UILabel!
    @IBOutlet var snoozeButton: UIButton!
    @IBOutlet weak var thatime: UILabel!
    @IBOutlet var readyUp: UIButton!
    @IBOutlet weak var countdown: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let audioFilePath = NSBundle.mainBundle().pathForResource("alarm", ofType: "mp3")
        
        if audioFilePath != nil {
            
            let audioFileUrl = NSURL.fileURLWithPath(audioFilePath!)
            
            audioPlayer = try! AVAudioPlayer(contentsOfURL: audioFileUrl)
            audioPlayer.play()
            
        }
        
    }
    @IBAction func startCountdown(sender: AnyObject) {
    }
    @IBAction func snoozePressed(sender: AnyObject) {
        audioPlayer.stop()
    }
    @IBAction func readyPressed(sender: AnyObject) {
        audioPlayer.play()
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
