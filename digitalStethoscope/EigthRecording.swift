//
//  EigthRecording.swift
//  digitalStethoscope
//
//  Created by Sofia Briquet on 4/4/20.
//  Copyright © 2020 Andrew Stoycos. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMotion
import MessageUI
import Accelerate

class EigthRecording: UIViewController, AVAudioRecorderDelegate, MFMailComposeViewControllerDelegate,UITextFieldDelegate {

    // MARK: VARIABLE DECLARATION
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var numberOfFiles: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var isRecording = false
           let motion = CMMotionManager()
           var accdata: [Float] = []
           var upsampledAccdata: [Float] = []
           var buttonTimer = Timer()
           var milseconds = 0//This variable will hold a starting value of seconds. It could be any amount above 0.
           var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
           var accrecordTime: Double = 0.0
           var startTime: Double = 0
           var accrecordTime2 : Double = 0.0
           var audioFilename : URL!
           
           // MARK: Setupfunction
           override func viewDidLoad() {
               super.viewDidLoad()
               recordButton.layer.cornerRadius = 5
               nextButton.layer.cornerRadius = 5
            nextButton.isHidden = true
            statusLabel.text = "Tap to Record"
           }
           
           func setupRecorder() {
               
               statusLabel.text = "Tap to Record"
               
               milseconds = 0//This variable will hold a starting value of seconds. It could be any amount above 0.
               isTimerRunning = false //This will be used to make sure only one timer is created at a time.a
               accrecordTime = 0.0
               startTime = 0
               accrecordTime2 = 0.0
               
              //MARK: AUDIO HANDLING
               //Set up Audio File name and directory
               
               let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
               
               audioFilename = paths [0] .appendingPathComponent("BelowLeftScapula\(fileNumber).wav")
             
               let settings =
                   [
                       AVFormatIDKey:kAudioFormatLinearPCM,
                       AVLinearPCMBitDepthKey:32,
                       AVLinearPCMIsFloatKey: true,
                       AVSampleRateKey: 8000,
                       AVNumberOfChannelsKey: 1
                       ] as [String : Any]
               
               //Setup recording session settings
               let recordingSession: AVAudioSession =  AVAudioSession.sharedInstance()
               do {
                   try
                       recordingSession.setCategory(AVAudioSession.Category.playAndRecord)
               } catch {}
               do {
               
                   try recordingSession.setActive(true)
                   try recordingSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
                   recordingSession.requestRecordPermission() { [unowned self] allowed in
                       DispatchQueue.main.async {
                           if allowed {
                               
                           } else {
                               print("Failed to Record")
                               // failed to record!
                           }
                       }
                   }
               } catch {
                   print("failed to record!")
               }
               
               //Setup file path for recording sessiion
               do {
                   audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
               } catch let error as NSError {
                   print("audioSession error: \(error.localizedDescription)")
               }
               
               
           }

          //MARK: ACCELEROMETER HANDLING
           // function to start acclerometers
           func startAccelerometers(){
              
               if self.motion.isAccelerometerAvailable {
                   self.motion.accelerometerUpdateInterval = 1.0 / 80.0
                   //  ~80 hz
                   self.motion.startAccelerometerUpdates()
                   let startTime2 = Date().timeIntervalSinceReferenceDate
                   // Configure a timer to fetch the data.
                   let timer = Timer(fire: Date(), interval: (1.0 / 80.0),
                                     repeats: true, block: { (timer) in
                                       // Get the accelerometer data.
                                       if let data = self.motion.accelerometerData {
                                           let z = data.acceleration.z
                                           
                                           // Use the accelerometer data in your app.
                                           self.accdata.append(2*Float(z))
                                       }
                                       self.accrecordTime2 = Date().timeIntervalSinceReferenceDate - startTime2
                   })
                   
                   // Add the timer to the current run loop.
                   RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
               }

           }
           
           
           @objc func updateTimer() {
                   accrecordTime = Date().timeIntervalSinceReferenceDate - startTime
           
           }
           
           func runTimer() {
               startTime = Date().timeIntervalSinceReferenceDate
               buttonTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)    }
           
           //Create and setup 2 channel .wav
           func setupTwoChanneledWave() {
               let actualRate = Double(accdata.count) / (accrecordTime2)
               let SAMPLE_RATE =  8000;
               
               print("The acclerometer time recorded \(accrecordTime2)")
               print("The second real sampling rate is \(Double(accdata.count)/accrecordTime2)")
               print("The time recorded \(accrecordTime)")
               print("The real sampling rate is \(actualRate)")
               
               let outputFormatSettings = [
                   AVFormatIDKey:kAudioFormatLinearPCM,
                   AVLinearPCMBitDepthKey:32,
                   AVLinearPCMIsFloatKey: true,
                   //  AVLinearPCMIsBigEndianKey: false,
                   AVSampleRateKey: SAMPLE_RATE,
                   AVNumberOfChannelsKey: 2
                   ] as [String : Any]
               
               let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
               
             /// let accFilename = paths[0].appendingPathComponent("BelowLeftScapula\(fileNumber).wav")
            let accFilename = paths[0].appendingPathComponent("acc_TOP_audio_BOTTOM\(fileNumber).wav")
               print(accFilename)
               
               let audioFile = try? AVAudioFile(forWriting: accFilename, settings: outputFormatSettings, commonFormat: AVAudioCommonFormat.pcmFormatFloat32, interleaved: true)
               
               //buffer for audio and acc separately
               
               
               let outputFormatSettings3 = [
                   AVFormatIDKey:kAudioFormatLinearPCM,
                   AVLinearPCMBitDepthKey:32,
                   AVLinearPCMIsFloatKey: true,
                   //  AVLinearPCMIsBigEndianKey: false,
                   AVSampleRateKey: SAMPLE_RATE,
                   AVNumberOfChannelsKey: 1
                   ] as [String : Any]
               
               let bufferFormat = AVAudioFormat(settings: outputFormatSettings3)
               
               let outputBuffer = AVAudioPCMBuffer(pcmFormat: bufferFormat!, frameCapacity: AVAudioFrameCount(accrecordTime2 * Double(SAMPLE_RATE)))
               let outputBuffer2 = AVAudioPCMBuffer(pcmFormat: bufferFormat!, frameCapacity: AVAudioFrameCount(accrecordTime2 * Double(SAMPLE_RATE)))
               
               let file = try! AVAudioFile(forReading: audioFilename)
               
               try? file.read(into: outputBuffer2!)
               
               
               // Resize acclerometer data to match Audio sampling rate
               
               func resample<T>(array: [T], toSize newSize: Int) -> [T] {
                   let size = Int(array.count)
                   return (0 ..< newSize).map { array[$0 * size / newSize] }
               }
               
               let resampledaccData = resample(array: accdata, toSize: (Int(outputBuffer2!.frameLength)) )//Int(accrecordTime2) * SAMPLE_RATE)
               
               // make combined buffer in interleaved(Right/Left) format
               
               let bufferformat3 = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: Double(SAMPLE_RATE), channels: 2, interleaved: true)
               
               let outputBuffer3 = AVAudioPCMBuffer(pcmFormat: bufferformat3!, frameCapacity: AVAudioFrameCount(resampledaccData.count * 2))
               
               //  I had my samples in doubles, so convert then write
               // Load acc and audio data into new buffer in alternating order
               for i in 0..<resampledaccData.count {
                   
                   outputBuffer?.floatChannelData!.pointee[i] = Float( resampledaccData[i])
                   outputBuffer3?.floatChannelData!.pointee[(2*i)] = (outputBuffer?.floatChannelData!.pointee[i])!
                   outputBuffer3?.floatChannelData!.pointee[(2*i) + 1] = (outputBuffer2?.floatChannelData!.pointee[i])!;
                   
               }
               outputBuffer3?.frameLength = AVAudioFrameCount(outputBuffer2!.frameLength)
               
               // Write from combined buffer to two channeled audio file
               do{
                   try audioFile!.write(from: outputBuffer3!)
                   
               } catch let error as NSError {
                   print("error: File not written", error.localizedDescription)
               }
           }
           //occurs when record button is pushed, triggers when 3 second timer runs out
           @objc func beginRecoding(timer: Timer) {
               fileNumber = fileNumber + 1;
               numberOfFiles.text = String(fileNumber)
               setupRecorder()
               runTimer()
               startAccelerometers()
               audioRecorder?.record()
               isRecording = true
               statusLabel.text = "RECORDING"
           }
    
    //MARK: RECORD BUTTON ACTIONS
           //occurs when end button is pushed
           @objc func endRecoding(timer: Timer) {
               
               audioRecorder?.stop()
               isRecording = false
               statusLabel.text = "FINISHED RECORDING"
               self.motion.stopAccelerometerUpdates()
               buttonTimer.invalidate()
               print(accdata.count)
               setupTwoChanneledWave()
            nextButton.isHidden = false
            recordButton.isEnabled = false
               
           }
           
           
           //Record button actions
           
           //Timers start when record button is pressed
           @IBAction func recordBaby(_ sender: UIButton) {
               
           if isRecording == false  {
               Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(beginRecoding(timer:)), userInfo: nil, repeats: false)
               statusLabel.text = "STANDBY"
               Timer.scheduledTimer(timeInterval: 9, target: self, selector: #selector(endRecoding(timer:)), userInfo: nil, repeats: false)
               
               
               
               }

       }
           
       //A few error handling functions
           func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
           }
           
           func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
               print("Audio Record Encode Error")
           }
    
}
