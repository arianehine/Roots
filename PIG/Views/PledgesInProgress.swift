//
//  PledgesInProgress.swift
//  PIG
//
//  Created by ariane hine on 07/06/2021.
//
import WrappingHStack
import SwiftUI
import ToastSwiftUI
import FirebaseFirestore
import FirebaseAuth
import UserNotifications

struct PledgesInProgress: View {
    @State var showFurtherInfo :Bool = false
    @State var defaultNotifs = false
    @State var statsController: StatsDataController
    @State var showFurtherInfoProgress:Bool = false
    @EnvironmentObject var fbLogic: FirebaseLogic
    @State var selectedForFurtherInfo: Pledge = emptyPledge;
    @State var durationSelected: Int?
    var pledgePicked: Pledge?
    @State var morePledges = false
    @EnvironmentObject var viewModel: AppViewModel
    var body: some View {
        
        VStack{

        Text("Pledges in progress...")
            WrappingHStack(0..<fbLogic.pledgesInProgress.count, id:\.self, alignment: .center) { index in
                
                VStack{
                  


                        Button(action: {
                        
                            showFurtherInfo = true
                            showFurtherInfoProgress = true
                            selectedForFurtherInfo = fbLogic.pledgesInProgress[safe: index] ?? emptyPledge

                              }) {
                                  Image(systemName: fbLogic.pledgesInProgress[safe: index]?.imageName ?? "figure.walk").renderingMode(.original)
                                
                                .resizable()
                                .foregroundColor(setTextColor(worstArea: fbLogic.pledgesInProgress[safe: index]?.category ?? "figure.fill"))
                                .frame(width: 50, height: 50, alignment: .center)
                               
                               
                                  
                              }
                    if #available(iOS 15.0, *) {
                        Toggle("Notifs?", isOn: $fbLogic.pledgesInProgress[safe: index]?.notifications ?? $defaultNotifs).padding(.leading)
                            .toggleStyle(SwitchToggleStyle(tint: .green)).onChange(of: fbLogic.pledgesInProgress[safe: index]?.notifications, perform: {value in
                                
                                if(value ?? false){
                                    //turn notifs on
                                    requestPermissions(pledge: fbLogic.pledgesInProgress[safe: index] ?? emptyPledge, value: value ?? false)
                                }else{
                                    //turn them off
                                }
                                
                                
                                
                                fbLogic.turnNotificationsOn(pledge: fbLogic.pledgesInProgress[safe: index] ?? emptyPledge, value: value ?? false)
                                
                            }
                                                                                   
                                                                                   
                                                                                   
                            )
                    } else {
                        // Fallback on earlier versions
                    }

                       
                    

                    let calendar = Calendar.current
                    let endDate = Calendar.current.date(byAdding: .day, value:  fbLogic.pledgesInProgress[safe: index]?.durationInDays ?? 0, to: fbLogic.pledgesInProgress[safe: index]?.startDate ?? Date())
                  
    
                    let date1 = calendar.date(bySettingHour: 12, minute: 00, second: 00, of: calendar.startOfDay(for:  Date()))
                    let date2 = calendar.date(bySettingHour: 12, minute: 00, second: 00, of: calendar.startOfDay(for: endDate ?? Date()))

                    let components = calendar.dateComponents([.day], from: date1!, to: date2!)
                    let numDays : Int = components.day!
                    Text("Days remaining: \(numDays)").font(.caption)

                }.frame(width: 150, height: 150, alignment: .center);
                       
        
                      
            }
               
            Divider()
            Text("Pledges complete")
            WrappingHStack(0..<fbLogic.pledgesCompleted.count, id:\.self, alignment: .center) { index in

                ZStack{

                    Button(action: {
              
                        showFurtherInfo = true
                        selectedForFurtherInfo = fbLogic.pledgesCompleted[index]

                          }) {
                        Image(systemName: fbLogic.pledgesCompleted[index].imageName).renderingMode(.original)
                            .resizable()
                            .foregroundColor(setTextColor(worstArea: fbLogic.pledgesInProgress[safe: index]?.category ?? "figure.fill"))
                            .frame(width: 50, height: 50, alignment: .center)
                           
                          }
                   
                }
                                    }
                            
                                
      
                 

            Button(action: {
                
                self.morePledges = true
                
            }) {
                
            Text("Take more pledges?").padding(.vertical).padding(.horizontal,25).foregroundColor(.white)
            }
            .background(LinearGradient(gradient: .init(colors: [Color("Color"),Color("Color1")]), startPoint: .leading, endPoint: .trailing))
            .clipShape(Capsule())
            
            Spacer()
            
           

        }
        
        .toast(isPresenting: $showFurtherInfo, message: selectedForFurtherInfo.description).onAppear(perform: initVars)
        .background(
            VStack{
            NavigationLink(destination: AdditionalPledgesView(ID: "average", fbLogic: fbLogic, statsController: statsController), isActive: $morePledges) {
                            
                        }
            .hidden();
                
                NavigationLink(destination: TrackPledges(selectedForFurtherInfo: selectedForFurtherInfo, statsController: statsController).environmentObject(viewModel), isActive: $showFurtherInfoProgress) {
                            
                        }
                        .hidden()
            }
                    )
            
                    
 
    }
    func setNotifReminder(pledge: Pledge){
   
        let content = UNMutableNotificationContent()
        content.title = "Complete your pledge"
        content.subtitle = "\(pledge.description)"
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: true)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)

    }
    func requestPermissions(pledge: Pledge, value: Bool){
       
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
           
            if success && value{
  
                    setNotifReminder(pledge: pledge)
              
                
            } else if let error = error {
     
                Swift.print(error.localizedDescription)
             
            }
        }
     
    }
    func initVars(){
 
        fbLogic.allPledges = fbLogic.getAllPledges();
        fbLogic.checkIfAnyPledgesToReset()
        fbLogic.allPledges = fbLogic.getAllPledges();
        fbLogic.pledgesCompleted = fbLogic.getPledgesCompleted()
        fbLogic.pledgesInProgress = fbLogic.getPledgesInProgress(pledgePicked: pledgePicked ?? emptyPledge, durationSelected: durationSelected ?? 7)
  
       
    }
}




let emptyPledge = Pledge(id: 1, description: "nil", category: "nil", imageName: "nil", durationInDays: 0, startDate: Date(), started: false, completed: false, daysCompleted: 0, endDate: "", XP: 0, notifications: false, reductionPerDay: 0)
