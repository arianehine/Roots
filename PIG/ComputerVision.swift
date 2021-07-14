//
//  ComputerVision.swift
//  PIG
//
//  Created by ariane hine on 14/07/2021.
//

import SwiftUI
struct ComputerVision: View {
    @State private var classificationLabel: String = ""
    let model = MobileNetV2()
    var body: some View {
        VStack{
            if(classificationLabel.contains("trash can")){
                Text("This image is of a trash can")
            }else{
                Text("NOT a trash can")
            }
        Button("classify"){
            self.performImageClassification()
        }
        }
    }
    private func performImageClassification(){
        let img = UIImage(named: "images")
        let resizedImage = img!.resizeTo(modelSize: CGSize(width: 224, height: 224))
        let buffer = resizedImage.buffer()
        let output = try? model.prediction(image: buffer!)
     
        
        if let output = output {
            self.classificationLabel = output.classLabel
            
            //key: string, confidence level: double
            let results = output.classLabelProbs.sorted { $0.1 > $1.1 }
            let result = "\(results[0].key) - confidence: \(results[0].value)"
            classificationLabel = result
        }
        
    }
}


func classify(){
    
    
}
struct ComputerVision_Previews: PreviewProvider {
    static var previews: some View {
        ComputerVision()
    }
}
extension UIImage{
    func buffer() -> CVPixelBuffer? {
      let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
      var pixelBuffer : CVPixelBuffer?
      let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(self.size.width), Int(self.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
      guard (status == kCVReturnSuccess) else {
        return nil
      }

      CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
      let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

      let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
      let context = CGContext(data: pixelData, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

      context?.translateBy(x: 0, y: self.size.height)
      context?.scaleBy(x: 1.0, y: -1.0)

      UIGraphicsPushContext(context!)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
      UIGraphicsPopContext()
      CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

      return pixelBuffer
    }
    
    func resizeTo(modelSize: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(modelSize, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: modelSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
