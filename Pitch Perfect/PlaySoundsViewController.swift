//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Christopher Burgess on 3/5/15.
//  Copyright (c) 2015 Christopher Burgess. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    // global variables
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!    // receive audio file from RecordSoundViewController
    var audioEngine:AVAudioEngine! // AVAudioEngine object
    var audioFile:AVAudioFile! // AVAudioFile object
    var echoEngine:AVAudioEngine! // separate AVAudioEngine object for echo effect
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil) // creates AVAudioPlayer object
        audioPlayer.enableRate = true   // enable rate adjustment
        
        // initialize the audioEngine variable
        audioEngine = AVAudioEngine()
        
        // intialize the audioFile variable using the path to the receivedAudio file
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        // initialize the echoEngine variable
        echoEngine = AVAudioEngine()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // sets the rate to 0.5 (slow)
    @IBAction func playSlow(sender: UIButton) {
        // play audio slowly
        playAudio(0.5)
    }

    // sets the rate to 2.0 (fast)
    @IBAction func playFast(sender: UIButton) {
        // play audio fast
        playAudio(2.0)
    }
    
    func playAudio(playRate: Float)
    {
        // stop and reset the audioPlayer, audioEngine, and echoEngine
        stopAllAudio()
        
        audioPlayer.play()
        audioPlayer.rate = playRate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        stopAllAudio()
    }
    
    func stopAllAudio()
    {
        audioPlayer.stop()  // stops audio player
        audioEngine.stop() // stops audioEngine
        audioEngine.reset() // reset audioEngine
        echoEngine.stop() // stops echoEngine
        echoEngine.reset() // reset echoEngine
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        // stop all audio before playing
        stopAllAudio()
        
        // create the AVAudioPlayerNode object
        var audioPlayerNode = AVAudioPlayerNode()
        // attach the AVAudioPlayerNode to AVAudioEngine
        audioEngine.attachNode(audioPlayerNode)
        
        // create the AVAudioUnitTimePitch object
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        // attach the AVAudioUnitTimePitch to AVAudioEngine
        audioEngine.attachNode(changePitchEffect)
        
        // connect AVAudioPlayerNode to AVAudioUnitTimePitch
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        // connect AVAudioUnitTimePitch to Output
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)

        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        // play the modified audioPlayerNode
        audioPlayerNode.play()
    }
    
    @IBAction func playChipmunk(sender: UIButton) {
        stopAllAudio()
        playAudioWithVariablePitch(1000)
    }
        
    @IBAction func playDarth(sender: UIButton) {
        stopAllAudio()
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playEcho(sender: UIButton) {
        stopAllAudio()
        
        // create the echo AVAudioPlayerNode object
        var echoPlayerNode = AVAudioPlayerNode()
        // attach the echo AVAudioPlayerNode to echo AVAudioEngine
        echoEngine.attachNode(echoPlayerNode)
        
        // create reverb parameter variable and set
        var reverb = AVAudioUnitReverb()
        reverb.loadFactoryPreset(AVAudioUnitReverbPreset(rawValue: 4)!)
        reverb.wetDryMix = 50.0
        
        // attach the reverb node to the echoEngine
        echoEngine.attachNode(reverb)
        
        // connect the reverb node to the EchoPlayerNode
        echoEngine.connect(echoPlayerNode, to:reverb, format:nil)
        // connect the outputNode to the reverb node
        echoEngine.connect(reverb, to:echoEngine.outputNode, format:nil)
        
        echoPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        echoEngine.startAndReturnError(nil)
        
        // play the modified echoPlayerNode
        echoPlayerNode.play()
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
