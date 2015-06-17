//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Christopher Burgess on 3/4/15.
//  Copyright (c) 2015 Christopher Burgess. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var pausedLabel: UILabel!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var tapToRecordLabel: UILabel!
    @IBOutlet weak var pauseInstructionLabel: UILabel!
    @IBOutlet weak var stopInstructionLabel: UILabel!
    @IBOutlet weak var tapToContinueLabel: UILabel!
    
    // global variables
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var session:AVAudioSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // hide stop button and disable record button when view is first loaded
        stopButton.hidden = true
        recordButton.enabled = true
        pauseButton.hidden = true
        pausedLabel.hidden = true
        resumeButton.hidden = true
        tapToRecordLabel.hidden = false
        pauseInstructionLabel.hidden = true
        stopInstructionLabel.hidden = true
        tapToContinueLabel.hidden = true
    }

    // record the user's voice
    @IBAction func recordAudio(sender: UIButton) {
        // show "Recording..." text
        recordingInProgress.hidden = false
        // show the stop button
        stopButton.hidden = false
        // disable the record button after pressed
        recordButton.enabled = false
        // show the pause button
        pauseButton.hidden = false
        // hide instruction label
        tapToRecordLabel.hidden = true
        // show pause and stop instruction labels
        pauseInstructionLabel.hidden = false
        stopInstructionLabel.hidden = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        // set up an audio session
        session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        // initialize and prepare the recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        
        audioRecorder.delegate = self
        
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    // function that confirms recording file is processed before moving on to next view
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        // set the audio output to the speaker (instead of the earphone)
        session.setCategory(AVAudioSessionCategoryAmbient, error: nil)
        
        // if the successfully flag is true
        if(flag) {
            // save the recorded audio
            recordedAudio = RecordedAudio(filePathURL: recorder.url, title: recorder.url.lastPathComponent!) // initialize the object using default constructor of RecordedAudio class
            
            // move to the next scene (perform segue)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else {
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    // pause the recording
    @IBAction func pauseRecording(sender: UIButton) {
        // hide "Recording..." text
        recordingInProgress.hidden = true
        
        // show the paused label
        pausedLabel.hidden = false
        // hide the pause button
        pauseButton.hidden = true
        pauseInstructionLabel.hidden = true
        // show the resume button
        resumeButton.hidden = false
        // show the continue label
        tapToContinueLabel.hidden = false

        // stop recording the user's voice
        audioRecorder.pause()
    }
    
    // resumes the recording after being paused
    @IBAction func resumeRecording(sender: UIButton) {
        // resume recording
        audioRecorder.record()
        
        // show recording label again
        recordingInProgress.hidden = false
        // hide paused label
        pausedLabel.hidden = true
        // show stop button again
        stopButton.hidden = false
        // show pause button again
        pauseButton.hidden = false
        pauseInstructionLabel.hidden = false
        // hide resume button
        resumeButton.hidden = true
        // hide the continue label
        tapToContinueLabel.hidden = true
    }
    
    // custom segue when stop button is pressed
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording")
        {
            // specifies the View Controller
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            // pass the data from this view
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    // hide the recording label and stop recording when stop button is pressed
    @IBAction func hideRecording(sender: UIButton) {
        // hide "Recording..." text
        recordingInProgress.hidden = true
        // stop recording the user's voice
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

