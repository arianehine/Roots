//
//  PledgeUpdate.swift
//  PIG
//
//  Created by ariane hine on 25/06/2021.
//

import SwiftUI
import FirebaseAuth

struct PledgeUpdate: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State var pledgeToUpdate: Pledge
    @State var fbLogic: FirebaseLogic = FirebaseLogic();
    @State var toastShow: Bool = false
    @State var showAlert: Bool = false
    @State var goBack = false
    @State var auth = Auth.auth();
    @State var message = ""
    @State var showWalkModal = false
    @State var showRecycleModal = false
    @State var showRecycleCamera = false
    @State var completed = false
    @State var statsController: StatsDataController
    @State var csvHandler = CSVHandler(fbLogic: FirebaseLogic())

    var body: some View {
        VStack{
            if (goBack) {
                PledgesInProgress(statsController: statsController).environmentObject(fbLogic).environmentObject(viewModel)
            } else{
            
        Text("Track activity for pledge").font(.title2)
        Text("Pledge: \(pledgeToUpdate.description)")
        Text("Days until finished: \(pledgeToUpdate.durationInDays - pledgeToUpdate.daysCompleted)")
        //TODO: make sure this can only be done once every day
    
        Button(action: {
            if(allowedToTrack(pledgeInQuestion: pledgeToUpdate)){
            if(pledgeToUpdate.description.contains("Walk to work")){
                
                showWalkModal = true;
       
                    
            }else if(pledgeToUpdate.description.contains("Recycle")){
                showAlert = true
                
              
                
            }else{
     
            updatePledge(pledgeToUpdate: pledgeToUpdate, daysCompleted: pledgeToUpdate.daysCompleted, durationInDays: pledgeToUpdate.durationInDays)

            toastShow = true
            
          
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    goBack = true
                       }
            }
            }else{
              message = "Oops, come back tomorrow to track progress for this pledge"
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    goBack = true
                       }
            }
            
        }) {
          
            
            //check if pledge is walk to work, if it is track location.
            
        Text("+1 to pledge count").padding(.vertical).padding(.horizontal,25).foregroundColor(.white)
        }.onChange(of: completed) { value in
            if value == true {
               
                
               
        
                    updatePledge(pledgeToUpdate: pledgeToUpdate, daysCompleted: pledgeToUpdate.daysCompleted, durationInDays: pledgeToUpdate.durationInDays)
                    toastShow = true

              
              
                
              
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        goBack = true
                
            }
            }
        } .background(LinearGradient(gradient: .init(colors: [Color("Color"),Color("Color1")]), startPoint: .leading, endPoint: .trailing))
        .clipShape(Capsule())
            }
        }.onAppear(){
     
            self.csvHandler.fbLogic = self.fbLogic
        }
        .sheet(isPresented: $showWalkModal) { MapView(completed: $completed, showingModal: $showWalkModal) }
        .sheet(isPresented: $showRecycleCamera) { CameraView(completed: $completed, showModal: $showRecycleCamera)}
        .sheet(isPresented: $showRecycleModal) { Recycling(completed: $completed, showingRecycleModal: $showRecycleModal) }
        .toast(isPresenting: $toastShow, message: getMessage(pledgeToUpdate: pledgeToUpdate, daysCompleted: pledgeToUpdate.daysCompleted, durationInDays: pledgeToUpdate.durationInDays))
        .alert(isPresented: $showAlert){
            Alert(title: Text("How would you like to track this pledge?"), message: Text("Select option..."), primaryButton: .default (Text("Track walk")) {
              
                self.trackWalkCallback()             // << here !!
          },secondaryButton: .default (Text("Take picture")) {
           
            self.takePictureCallback()}
            )

        }
        
   
    }
    

    func allowedToTrack(pledgeInQuestion: Pledge)->Bool{
        return true
    }
    func trackWalkCallback(){
        showRecycleModal = true
    }
    func takePictureCallback(){
        showRecycleCamera = true
    }
    func getMessage(pledgeToUpdate: Pledge, daysCompleted: Int, durationInDays: Int) -> String{
       return message
        }
    
    //TODO IMPLEMENT THIS
    func updatePledge(pledgeToUpdate: Pledge, daysCompleted: Int, durationInDays: Int){
 
        auth = Auth.auth()
        
       self.fbLogic.incrementPledgeCompletedDays(pledge: pledgeToUpdate, uid: auth.currentUser!.uid){ (isSucceeded) in
           
            if !isSucceeded {
                
             
               
                message = "Oops, come back tomorrow to track progress for this pledge"
                
              
            } else {
              

                if((daysCompleted+1) == durationInDays){
           
                    self.fbLogic.incrementPledgeCompletedDays2(pledge: pledgeToUpdate, uid: auth.currentUser!.uid)
                    self.fbLogic.incrementUserXPPledge(pledge: pledgeToUpdate, uid: auth.currentUser!.uid);
                    
               message =  "Yay, you've completed this pledge. + \(pledgeToUpdate.XP) XP "
                }else{
           
                    self.fbLogic.incrementPledgeCompletedDays2(pledge: pledgeToUpdate, uid: auth.currentUser!.uid)
                    self.fbLogic.incrementUserXP(amount: 10, uid: auth.currentUser!.uid)
                  message = "Well done! Only \(durationInDays - (daysCompleted+1)) days until you are finished"
                   
                }
               
                let dataToReduceBy = self.csvHandler.getReductionData(amount: pledgeToUpdate.reductionPerDay, days: pledgeToUpdate.durationInDays, pledgeArea: pledgeToUpdate.category, footprint: viewModel.footprint)
                
                self.fbLogic.addData(user: dataToReduceBy, userId: auth.currentUser!.uid);

                self.statsController.originalPeople.append(dataToReduceBy)

            }
     
        
    }
}
}
