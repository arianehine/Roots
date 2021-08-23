//
//  CameraView.swift
//  PIG
//
//  Created by ariane hine on 14/07/2021.
//

import SwiftUI
import AVFoundation

//The view which is used to take a picture of the recycling bin
struct CameraView: View {
    
    @StateObject var camera = CameraModel()
    @Binding var completed: Bool
    @Binding var showModal: Bool
    
    var body: some View{
        
        ZStack{
            //Shows live camera preview
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
            
            VStack{
                
                //If photo is taken the show it on the screen
                if camera.isTaken{
                    
                    HStack {
                        
                        Spacer()
                        
                        Button(action: camera.reTake, label: {
                            
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        })
                            .padding(.trailing,10)
                    }
                }
                
                Spacer()
                
                HStack{
                    
                    // If taken show the save and retake buttons
                    if camera.isTaken{
                        
                        Button(action: {if !camera.isSaved{camera.savePic()}}, label: {
                            Text(camera.isSaved ? "Saved" : "Save")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .padding(.vertical,10)
                                .padding(.horizontal,20)
                                .background(Color.white)
                                .clipShape(Capsule())
                        })
                            .padding(.leading)
                        
                        Spacer()
                    }
                    else{
                        
                        Button(action: camera.takePic, label: {
                            ZStack{
                                
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65, height: 65)
                                
                                Circle()
                                    .stroke(Color.white,lineWidth: 2)
                                    .frame(width: 75, height: 75)
                            }
                        })
                    }
                }
                .frame(height: 75)
            }
        }
        .onAppear(perform: {
            
            camera.Check()
        })
        .alert(isPresented: $camera.alert) {
            Alert(title: Text("Please Enable Camera Access"))
        }
        .alert(isPresented: $camera.isOfTrashCan) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.completed = true
                showModal = false;
            }
            
            //Return sucess alert if the label was of a bin, after ML model processing
            return Alert(title: Text("Yay, you've recycled!"))

        }
    }
}

