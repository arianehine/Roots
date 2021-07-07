//
//  Recycling.swift
//  PIG
//
//  Created by ariane hine on 07/07/2021.
//

import SwiftUI
import MapKit
import CoreLocation

struct Recycling: View {
    @StateObject var mapData = MapViewModel()
    @Binding var completed: Bool
    // Location Manager....
    @Binding var showingModal: Bool
    @State var locationManager = makeLocationManager()
    @State var query = "Recycling centres"
    @State var places = [Place]()
    var body: some View {
        ZStack{
            
            // MapView...
   
            MapShower()
                // using it as environment object so that it can be used ints subViews....
                .environmentObject(mapData)
                
                .ignoresSafeArea(.all, edges: .all)
            
            if !mapData.places.isEmpty && mapData.searchTxt != ""{
                let result = mapData.appendAllPlaces(places: mapData.places, currentLocation: locationManager.location!)
            }
                Spacer()
                
                VStack{
                    VStack(spacing: 0){
                        HStack{
                            
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            
                            Button(action: {mapData.setSearchText(query: query)}, label: {
                                
                                Text("Find")
                            })
                        }
                        .padding(.vertical,10)
                        .padding(.horizontal)
                        .background(Color.white)
                    Spacer()
                    
                    Button(action: mapData.focusLocation, label: {
                        
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .padding(10)
                            .background(Color.primary)
                            .clipShape(Circle())
                    })
                    
                    Button(action: mapData.updateMapType, label: {
                        
                        Image(systemName: mapData.mapType == .standard ? "network" : "map")
                            .font(.title2)
                            .padding(10)
                            .background(Color.primary)
                            .clipShape(Circle())
                    })
  
                    Button(action: {
                        self.showingModal = false
                    }) {
                        Text("Quit finding recycling centres?").frame(height: 20)
                            
                    }.background(Color.white)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
            }   .alert(isPresented: $mapData.permissionDenied, content: {
                
                Alert(title: Text("Permission Denied"), message: Text("Please Enable Permission In App Settings"), dismissButton: .default(Text("Goto Settings"), action: {
                    
                    // Redireting User To Settings...
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }))
            })
        .onAppear(perform: {
                
                // Setting Delegate...
                locationManager.delegate = mapData
                locationManager.requestWhenInUseAuthorization()
//                locationManager.startMonitoring(for: mapData.circularRegion)
               
    //            mapData.requestNotificationAuthorization()
            })
        .onChange(of: mapData.searchTxt, perform: { value in
            
            // Searching Places...
            
            // You can use your own delay time to avoid Continous Search Request...
            let delay = 0.3
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                
                if value == mapData.searchTxt{
                    
                    // Search...
                    self.mapData.searchQuery()
                }else{
                    print("no")
                }
            }
        
        })
    }
          
        
    
}
}

//struct Recycling_Previews: PreviewProvider {
//    static var previews: some View {
//        Recycling()
//    }
//}
private func makeLocationManager() -> CLLocationManager {
  // 3
  let manager = CLLocationManager()
    manager.allowsBackgroundLocationUpdates = true
  // 4
    manager.startUpdatingLocation()
  return manager
}
