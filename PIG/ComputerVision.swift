//
//  ComputerVision.swift
//  PIG
//
//  Created by ariane hine on 14/07/2021.
//

import SwiftUI
struct ComputerVision: View {
    @State var classificationLabel: String = ""

    let model = MobileNetV2()
    var body: some View {
        VStack{
            if(classificationLabel.contains("trash can")){
                Text("This image is of a trash can")
            }else{
                Text("NOT a trash can, it is \(classificationLabel)")
            }
        Button("Take picture of recycle bin"){
            classificationLabel = self.performImageClassification(img: UIImage(named: "images")!)
        }.background(LinearGradient(gradient: .init(colors: [Color("Color"),Color("Color1")]), startPoint: .leading, endPoint: .trailing))
        .clipShape(Capsule())
        
        
    }
        }
    
    func performImageClassification(img: UIImage) ->String{
        print("performing")
        let resizedImage = img.resizeTo(modelSize: CGSize(width: 224, height: 224))
        print("1")
        let buffer = resizedImage.buffer()
        print("2")
        let output = try? model.prediction(image: buffer!)
        print("3")
     
        
        if let output = output {
            print("4")
            self.classificationLabel = output.classLabel
            
            //key: string, confidence level: double
            let results = output.classLabelProbs.sorted { $0.1 > $1.1 }
            let result = "\(results[0].key) - confidence: \(results[0].value)"
            print("\(result)")
            self.classificationLabel = result
            return result
        }
        print("5")
        print("classif label: \(self.classificationLabel)")
        return classificationLabel
        
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
