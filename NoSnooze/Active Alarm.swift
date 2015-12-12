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
    var timer = NSTimer() //make a timer variable, but don't do anything yet
    let timeInterval:NSTimeInterval = 0.05
    let timerEnd:NSTimeInterval = 1000.0
    var timeCount:NSTimeInterval = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        let audioFilePath = NSBundle.mainBundle().pathForResource("alarm", ofType: "mp3")
        
        if audioFilePath != nil {
            
            let audioFileUrl = NSURL.fileURLWithPath(audioFilePath!)
            
            audioPlayer = try! AVAudioPlayer(contentsOfURL: audioFileUrl)
            audioPlayer.play()
            
        }
        
    }
    func resetTimeCount(){
        timeCount = timerEnd
    }
    @IBAction func resetTimer(sender: UIButton) {
        timer.invalidate()
        resetTimeCount()
        thatime.text = timeString(timeCount)
    }
    @IBAction func startTimer(sender: UIButton) {
        if !timer.valid{ //prevent more than one timer on the thread
            thatime.text = timeString(timeCount)
            timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval,
                target: self,
                selector: "timerDidEnd:",
                userInfo: "Pizza Done!!",
                repeats: true) //repeating timer in the second iteration
        }
    }
    
    func timeString(time:NSTimeInterval) -> String {
        let minutes = Int(time) / 60
        //let seconds = Int(time) % 60
        let seconds = time - Double(minutes) * 60
        let secondsFraction = seconds - Double(Int(seconds))
        return String(format:"%02i:%02i.%01i",minutes,Int(seconds),Int(secondsFraction * 10.0))
    }
    func timerDidEnd(timer:NSTimer){
        timeCount = timeCount - timeInterval
        if timeCount <= 0 {
            thatime.text = "Pizza Ready!!"
            timer.invalidate()
        } else { //update the time on the clock if not reached
            thatime.text = timeString(timeCount)
        }
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
