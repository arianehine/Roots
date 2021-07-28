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



