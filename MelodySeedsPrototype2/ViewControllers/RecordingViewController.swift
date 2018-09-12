//
//  RecordingViewController.swift
//  MelodySeedsPrototype2
//
//  Created by Hunter Gregory on 8/18/18.
//  Copyright © 2018 Hunter Gregory. All rights reserved.
//

import UIKit
import AVFoundation

//audioRecorder has instance variables of isRecording and currentTime (latter returns 0 when recording stopped)
//audioPlayer has instance variable isPlaying, duration (constant), & currentTime (resets to where playing starts upon calling play() once playing has stopped)

class RecordingViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var stopPlayButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var recordingView: UIView!
    @IBOutlet weak var durationLabel: UILabel!
    
    var audioSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
    var pathURL: URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent(editedRecording.name).appendingPathExtension("m4a")
    }
    
    var timer: Timer!
    var counter: Double!
    var recording: Recording!
    var editedRecording: Recording!
    var isNewRecording: Bool!
    var cameFromHome: Bool!
    //^ true if from home view controller, false for came from individual projects
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ////// if update this, modify recording VC
        //set up back button that can have segues
        let customBackButton = UIButton(type: .custom)
        customBackButton.setImage(UIImage(named: "BackButtonWhite2"), for: .normal)
        //or just UIView( that image ^)...?
        backButton.customView = customBackButton
        //FIXXX   back Button doesn't go back
        
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        /////// audio
        audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            //try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            //not sure ^ if necessary
            try audioSession.setActive(true)
            audioSession.requestRecordPermission() { (allowed) in
                    if !allowed {
                        self.performSegue(withIdentifier: "UnwindToHome", sender: nil)
                    }
                }
            } catch {
                performSegue(withIdentifier: "UnwindToHome", sender: nil)
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //show navigation bar
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.title = recording.name
        
        //initialize recording variable
        editedRecording = recording
        counter = recording.duration
        UpdateTimer()
        updateUI()
        
        let shapeLayer = CAShapeLayer()
        let center = CGPoint(x: view.center.x, y: view.center.y + 100)
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2*CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        //shapeLayer.fillColor = UIColor.clear.cgColor
        
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.lineWidth = 10
        recordingView.layer.addSublayer(shapeLayer)
    }
    
    
    func startRecording() {
        editedRecording.isPlaying = true
        if audioRecorder == nil {
            do {
                audioRecorder = try AVAudioRecorder(url: pathURL, settings: settings)
                
                audioRecorder.delegate = self
                audioRecorder.record()
                updateRecordingButton()
            } catch {
                displayAlert(title: "Recording failed")
            }
        }
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        
        drawRecording()
    }
    
    //Not sure what to do when editing segue is called instead of new recording segue
    func continueRecording() {
        if audioRecorder == nil {
            do {
                audioRecorder = try AVAudioRecorder(url: pathURL, settings: settings)
            } catch {
                displayAlert(title: "recorder didn't work")
            }
        }
        if editedRecording.currentTime != editedRecording.duration {
            audioRecorder.record(atTime: editedRecording.currentTime)
        } else {
            audioRecorder.record()
        }
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        editedRecording.isPlaying = true
        updateButtons()
        drawRecording()
    }
    
    //not sure what to do if editing segue called instead of new recording segue
    @IBAction func startButtonPressed(_ sender: UIButton) {
        continueRecording()
        updateStopPlayButton()
    }
    
    @IBAction func stopPlayButtonPressed(_ sender: UIButton) {
        editedRecording.duration = audioRecorder.currentTime
        //stop actions
        if editedRecording.isPlaying {
            //update recording.duration
            timer.invalidate()
            editedRecording.duration = counter
            audioRecorder.pause()
        } else {
            //play actions
            audioRecorder.stop()
            do {
                if audioPlayer == nil {
                    audioPlayer = try AVAudioPlayer(contentsOf: audioRecorder.url)
                    audioPlayer.delegate = self
                }
                audioPlayer.play(atTime: audioPlayer.currentTime)
            } catch {
                displayAlert(title: "Audio Player didn't work")
            }
        }
        
        editedRecording.isPlaying = !editedRecording.isPlaying
        updateStopPlayButton()
        updateRecordingButton()
    }
    
   
    
    
    ///////     Animations     //////////
    
    func updateUI() {
        if isNewRecording {
            uploadNotes()
            //set up new recording stuff
            startRecording()
        } else {
            //set up old recording data
            if editedRecording.isPlaying {
                //set audio to play mode starting at editedRecording.currentTime
            }
        }
    }
    
    @objc func UpdateTimer() {
        //FIX   update counter if recording is cut
        
        counter = counter + 0.1
        durationLabel.text = String(format: "%0.1f", counter)
        //update recording drawing
        //FIX
        
        
    }
    
    func uploadNotes() {
        if let notes = editedRecording.notes {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 20
            let attributes = [NSAttributedStringKey.paragraphStyle : style]
            notesTextView.attributedText = NSAttributedString(string: notes, attributes: attributes)
        }
    }
    
    func updateButtons() {
        updateStopPlayButton()
        updateRecordingButton()
    }
    
    func updateStopPlayButton() {
        if editedRecording.isPlaying {
            stopPlayButton.setImage(UIImage(named: "stop button2 cropped"), for: .normal)
            let lightBlue = UIColor(red: 52, green: 159, blue: 252, alpha: 1.0)
            stopPlayButton.backgroundColor = lightBlue
        } else {
            stopPlayButton.setImage(UIImage(named: "play button2 cropped"), for: .normal)
            stopPlayButton.backgroundColor = UIColor.gray
        }
    }
    
    func updateRecordingButton() {
        if editedRecording.isPlaying {
            recordingButton.isEnabled = false
            recordingButton.backgroundColor = UIColor.gray
        } else {
            recordingButton.setTitle("Record", for: .normal)
            recordingButton.isEnabled = true
            recordingButton.backgroundColor = UIColor.green
        }
    }
    
    
    func drawRecording() {
        //updte drawing ofrecording
        
    }
    
    func displayAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    ///////      Segues       ///////
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        audioRecorder.stop()
        do {
            try audioSession.setActive(false)
        } catch {
            print("couldn't deactivate audio session")
        }
        performSegue(withIdentifier: "UnwindToHome", sender: sender)
    }
    
    //the play/pause or delete button...maybe code different buttons and put a different one there depending on situation
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        audioRecorder.stop()
        audioRecorder.deleteRecording()
        do {
            try audioSession.setActive(false)
        } catch {
            print("couldn't deactivate audio session")
        }
        /*switch sender.mode {
        case .delete: */
            performSegue(withIdentifier: "UnwindToHome", sender: nil)
        /*case .play:
            playAudio()
        case .pause:
            pauseAudio()
        }*/
    }
    
    //set sender == nil if I want nothing to happen (e.g. recording deleted, no recording permissions)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender != nil {
            if isNewRecording {
                //stuff
            } else if recording.duration != editedRecording.duration { //for edited recording
                //change name
                let oldName = editedRecording.name
                var editedName = oldName + " - Edited"
                if oldName.hasSuffix("- Edited") {
                    editedName = oldName + " again"
                } else if oldName.hasSuffix("- Edited again") {
                    editedName = oldName + "(and again...)"
                } else {
                    editedName = oldName
                }
            
                editedRecording.name = editedName
                editedRecording.date = Date()
                
                //override recording variable (they're different at this point bc Recording is a struct)
                recording = editedRecording
            }
        }
    }

}
