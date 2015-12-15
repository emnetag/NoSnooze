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
    
    @IBOutlet var Friends: UILabel!
    @IBOutlet var Cutoff: UILabel!
    var audioPlayer:AVAudioPlayer!
    @IBOutlet var alarmName: UILabel!
    @IBOutlet var snoozeButton: UIButton!
    @IBOutlet var readyUp: UIButton!
    var currAlarm : Alarm!
    var timer = NSTimer()
    let timeInterval:NSTimeInterval = 0.05
    var timeCount:NSTimeInterval = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        timer.invalidate()
        let audioFilePath = NSBundle.mainBundle().pathForResource("alarm", ofType: "mp3")
        alarmName.text = currAlarm.name
        if(currAlarm.members != nil) {
            var friends2 = ""
            for member in currAlarm.members! {
                friends2+=" \(member),"
            }
            Friends.text = friends2
        }
        timeCount = currAlarm.cutoffTime.timeIntervalSinceNow
        Cutoff.text = timeString(timeCount)
        timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval,
            target: self,
            selector: "timerDidEnd:",
            userInfo: "Timer",
            repeats: true) 
        if audioFilePath != nil {
            
            let audioFileUrl = NSURL.fileURLWithPath(audioFilePath!)
            
            audioPlayer = try! AVAudioPlayer(contentsOfURL: audioFileUrl)
            audioPlayer.play()
            
        }
        
    }
    func timerDidEnd(timer:NSTimer){
        timeCount = timeCount - timeInterval
        if timeCount <= 0 {
            timer.invalidate()
            audioPlayer.stop()
            let sb = UIStoryboard(name: "LandingPage", bundle: nil)
            let VC = sb.instantiateInitialViewController() as UIViewController!
            self.presentViewController(VC, animated: true, completion: nil)
        } else {
            Cutoff.text = timeString(timeCount)
        }
        
    }
    func timeString(time:NSTimeInterval) -> String {
        let minutes = Int(time) / 60
        //let seconds = Int(time) % 60
        let seconds = time - Double(minutes) * 60
        let secondsFraction = seconds - Double(Int(seconds))
        return String(format:"%02i:%02i.%01i",minutes,Int(seconds),Int(secondsFraction * 10.0))
    }
    
    @IBAction func snoozePressed(sender: AnyObject) {
        audioPlayer.stop()
    }
    @IBAction func readyPressed(sender: AnyObject) {
        audioPlayer.stop()
        timer.invalidate()
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
