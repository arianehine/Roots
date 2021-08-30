//
//  CameraModel.swift
//  CameraModel
//
//  Created by Ariane Hine on 28/07/2021.
//

import Foundation
import SwiftUI
import AVFoundation
//The class which is used to store tha camera model for the Camera View used for photographic recycling pledge completion
//Tutorial from Kavsoft on Youtube https://www.youtube.com/watch?v=8hvaniprctk
class CameraModel: NSObject,ObservableObject,AVCapturePhotoCaptureDelegate{
    
    @Published var isTaken = false
    
    @Published var session = AVCaptureSession()
    
    @Published var alert = false
    
    // Store picture data which we will read later
    @Published var output = AVCapturePhotoOutput()
    
    // The camera preview
    @Published var preview : AVCaptureVideoPreviewLayer!
    
    // Data of the picture we save
    @Published var image: UIImage = UIImage(named: "images")!
    @Published var isSaved = false
    
    @Published var picData = Data(count: 0)
    @Published var classificationLabel = ""
    @State var CV = ComputerVision()
    @Published var isOfTrashCan = false
    
    func Check(){
        
        // Checking camera has permission
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
            return
            // Setting Up Session
        case .notDetermined:
            // Requesting permission if not yet granted
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                
                if status{
                    self.setUp()
                }
            }
        case .denied:
            self.alert.toggle()
            return
            
        default:
            return
        }
    }
    
    //Set up the camera session and device settings
    func setUp(){
        
        do{
            
            self.session.beginConfiguration()
            
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            let input = try AVCaptureDeviceInput(device: device!)
            
            
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
            
        }
        catch{
            print(error.localizedDescription)
        }
        
        
    }
    
    //Take picture function, captures what the camera sees
    func takePic(){
        
        self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        
        DispatchQueue.global(qos: .background).async {
            
            self.session.stopRunning()
            
            DispatchQueue.main.async {
                
                withAnimation{self.isTaken.toggle()}
            }
        }
    }
    //Retake picture function
    func reTake(){
        
        DispatchQueue.global(qos: .background).async {
            
            print("retaking")
            self.session.startRunning()
            
            DispatchQueue.main.async {
                withAnimation{self.isTaken.toggle()}
                //clearing ...
                self.isSaved = false
                self.picData = Data(count: 0)
            }
        }
    }
    
    //Saves the data of the picture we have captured once taken
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if error != nil{
            print(error?.localizedDescription)
            return
        }
        
        print("pic taken...")
        DispatchQueue.main.async {
            guard let imageData = photo.fileDataRepresentation() else{return}
            
            self.picData = imageData
            guard let image = UIImage(data: self.picData) else{
                return}
        }
        
        
    }
    
    
    //If the user saves the picture, pass it through the ML model to obtain a class label. If the class suggests the photo contains a rubbish bin the complete the pledge.
    func savePic(){
        var classLabel = ""
        
        do {
            let localImage = UIImage(data: self.picData)
            
            
            if((localImage) != nil){
                classLabel = CV.performImageClassification(img: localImage!)
            }else{
                throw ValidationError.conversionIssue
            }
            
        }catch{
            let image = self.image
            classLabel = CV.performImageClassification(img: image)
            self.isSaved = true
        }
        print("saved Successfully....")
        
        //If trash can or pail, complete
        if(classLabel.contains("trash can") || classLabel.contains("pail")){
            isOfTrashCan = true
            
        }
        print("\(classLabel)")
        
    }
}
enum ValidationError: Error {
    case conversionIssue
}

// Setting view for preview
struct CameraPreview: UIViewRepresentable {
    
    @ObservedObject var camera : CameraModel
    
    func makeUIView(context: Context) ->  UIView {
        
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        // starting session
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
        
    }
}
