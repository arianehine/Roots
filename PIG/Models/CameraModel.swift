//
//  CameraModel.swift
//  CameraModel
//
//  Created by Ariane Hine on 28/07/2021.
//

import Foundation
import SwiftUI
import AVFoundation
class CameraModel: NSObject,ObservableObject,AVCapturePhotoCaptureDelegate{
    
    @Published var isTaken = false
    
    @Published var session = AVCaptureSession()
    
    @Published var alert = false
    
    // since were going to read pic data....
    @Published var output = AVCapturePhotoOutput()
    
    // preview....
    @Published var preview : AVCaptureVideoPreviewLayer!
    
    // Pic Data...
    
    @Published var image: UIImage = UIImage(named: "images")!
    @Published var isSaved = false
    
    @Published var picData = Data(count: 0)
    @Published var classificationLabel = ""
    @State var CV = ComputerVision()
    @Published var isOfTrashCan = false
    
    func Check(){
        
        // first checking camerahas got permission...
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
            return
            // Setting Up Session
        case .notDetermined:
            // retusting for permission....
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
    
    func setUp(){
        
        // setting up camera...
        
        do{
            
            // setting configs...
            self.session.beginConfiguration()
            
            // change for your own...
            
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            
            let input = try AVCaptureDeviceInput(device: device!)
            
            // checking and adding to session...
            
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
            
            // same for output....
            
            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
         
        }
        catch{
            print(error.localizedDescription)
        }

       
    }
    
    // take and retake functions...
    
    func takePic(){
        
        self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        
        DispatchQueue.global(qos: .background).async {
            
            self.session.stopRunning()
            
            DispatchQueue.main.async {
                
                withAnimation{self.isTaken.toggle()}
            }
        }
    }
    
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
            print("oops1")
            return}
        }
        
        
    }
    

    
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
            print("caught")
            let image = self.image
            classLabel = CV.performImageClassification(img: image)
            self.isSaved = true
        }
        print("saved Successfully....")
        
        // saving Image...
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        if(classLabel.contains("trash can")){
            isOfTrashCan = true
            print("yes this is a trash can")

        }
        print("\(classLabel)")
        
    }
}
enum ValidationError: Error {
      case conversionIssue
    
  }

// setting view for preview...

struct CameraPreview: UIViewRepresentable {
    
    @ObservedObject var camera : CameraModel
    
    func makeUIView(context: Context) ->  UIView {
     
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        // Your Own Properties...
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        // starting session
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
