//
//  AudioNoteViewController.swift
//  Foodie
//
//  Created by Chuiwen Ma on 12/8/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import AVFoundation

class AudioNoteViewController: UIViewController, AVAudioRecorderDelegate {
    
    // MARK: - Public API
    
    var managedObjectContext: NSManagedObjectContext? = AppDelegate.managedObjectContext
    var audioPath: NSURL?
    
    // MARK: - Outlets
    
    @IBOutlet private weak var recordButton: UIButton!
    @IBOutlet private weak var recordingLabel: UILabel!
    @IBOutlet private weak var stopButton: UIButton!
    @IBOutlet private weak var playButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction private func startRecording(sender: UIButton) {
        playButton.hidden = true
        recordingLabel.hidden = false
        stopButton.hidden = false
        recordButton.enabled = false
        do {
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let filePath = NSURL.fileURLWithPathComponents([dirPath,
                (defaults.currentUser ?? Constants.AudioDefaultPrefix) + Constants.AudioSuffix])
            
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
            audioRecorder?.delegate = self
            audioRecorder?.meteringEnabled = true
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
        } catch let error {
            print("Audio Recording Error: \(error)")
        }
    }
    
    @IBAction private func stopRecording(sender: UIButton) {
        recordingLabel.hidden = true
        stopButton.hidden = true
        playButton.hidden = false
        recordButton.enabled = true
        audioRecorder?.stop()
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setActive(false)
        } catch let error {
            print("Stop Recording Error: \(error)")
        }
    }
    
    @IBAction private func playSound(sender: UIButton) {
        if let audioPath = audioPath {
            do {
                audioPlayer = try AVAudioPlayer(contentsOfURL: audioPath)
                audioEngine = AVAudioEngine()
                audioFile = try AVAudioFile(forReading: audioPath)
                let session: AVAudioSession = AVAudioSession.sharedInstance()
                try session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
                audioPlayer?.stop()
                audioPlayer?.currentTime = 0.0
                audioPlayer?.play()
            } catch let error {
                print("Play Sound Error: \(error)")
            }
        } else {
            playButton.hidden = true
        }
    }
    
    // MARK: - Private Properties
    
    private var defaults = Defaults()
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var audioEngine: AVAudioEngine?
    private var audioFile: AVAudioFile?
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPath = getUserAudioPath()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        recordingLabel.hidden = true
        stopButton.hidden = true
        if getUserAudioPath() != nil {
            playButton.hidden = false
        } else {
            playButton.hidden = true
        }
    }
    
    // MARK: - Private Methods
    
    private func updateUserAudioPath(audioPath: NSURL) {
        if let uid = defaults.currentUser, context = managedObjectContext {
            if let user = User.queryUsers(uid, inManagedObjectContext: context).first {
                context.performBlock {
                    user.audioNotePathStr = "\(audioPath)"
                    do {
                        try context.save()
                    } catch let error {
                        print("Core Data Error: \(error)")
                    }
                }
            }
        }
    }
    
    private func getUserAudioPath() -> NSURL? {
        if let uid = defaults.currentUser, context = managedObjectContext {
            if let path = User.queryUsers(uid, inManagedObjectContext: context).first?.audioNotePath {
                return path
            }
        }
        return nil
    }
    
    // MARK: - Audio Recorder delegate
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            audioPath = recorder.url
            if let audioPath = audioPath {
                updateUserAudioPath(audioPath)
            }
        } else {
            // Recording not successful
            recordButton.enabled = true
            stopButton.hidden = true
            recordingLabel.hidden = true
            if getUserAudioPath() != nil {
                playButton.hidden = false
            } else {
                playButton.hidden = true
            }
        }
    }
}
