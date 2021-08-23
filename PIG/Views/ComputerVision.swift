//
//  ComputerVision.swift
//  PIG
//
//  Created by ariane hine on 14/07/2021.
//

import SwiftUI

//The class which does the processing of an image vis use of MobileNetV2 model
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
    
    //Put image through model and get output label
    func performImageClassification(img: UIImage) ->String{
        
        let resizedImage = img.resizeTo(modelSize: CGSize(width: 224, height: 224))
        let buffer = resizedImage.buffer()
        let output = try? model.prediction(image: buffer!)
        
        if let output = output {
            self.classificationLabel = output.classLabel
            
            //key: string, confidence level: double
            let results = output.classLabelProbs.sorted { $0.1 > $1.1 }
            let result = "\(results[0].key) - confidence: \(results[0].value)"
            print("\(result)")
            self.classificationLabel = result
            return result
        }
        return classificationLabel
        
    }
}



