//
//  Recycling.swift
//  PIG
//
//  Created by ariane hine on 07/07/2021.
//

import SwiftUI
import MapKit
import CoreLocation
//Partially inspired by https://kavsoft.dev/SwiftUI_2.0/Advance_MapKit
//Displayhs a map view with the points of the 5 nearest recycling centres
struct Recycling: View {
    @StateObject var mapData = MapViewModel()
    @Binding var completed: Bool
    @Binding var showingRecycleModal: Bool
    @State var locationManager = makeLocationManager()
    @State var query = "Recycling centres"
    @State var places = [Place]()
    var body: some View {
        ZStack{
            
            // MapView
            MapShower()
            // Using map data as environment object so that it can be used in subViews
                .environmentObject(mapData)
                .ignoresSafeArea(.all, edges: .all)
            
            if !mapData.places.isEmpty && mapData.searchTxt != ""{
                let result = mapData.appendAllPlaces(places: mapData.places, currentLocation: locationManager.location!, locatioManager: locationManager)
                
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
                        self.showingRecycleModal = false
                    }) {
                        Text("Quit finding recycling centres?").frame(height: 20)
                        
                    }.background(Color.white)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
            }   .alert(isPresented: $mapData.permissionDenied, content: {
                
                Alert(title: Text("Permission Denied"), message: Text("Please Enable Permission In App Settings"), dismissButton: .default(Text("Goto Settings"), action: {
                    
                    // Redireting User To Settings
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }))
            })
                .onAppear(perform: {
                    
                    // Setting Delegate
                    locationManager.delegate = mapData
                    locationManager.requestWhenInUseAuthorization()
                    
                    
                })
                .onChange(of: mapData.searchTxt, perform: { value in
                    
                    // Searching Places
                    // Delay time to avoid Continous Search Request
                    if(mapData.searchTxt != ""){
                        let delay = 0.3
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                            
                            if value == mapData.searchTxt{
                                
                                // Search
                                self.mapData.searchQuery()
                            }else{
                                
                            }
                        }
                    }
                    
                })
            
        }.alert(isPresented: $mapData.didArriveAtDestination) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                self.completed = true
                self.showingRecycleModal = false
                
                for region in locationManager.monitoredRegions {
                    locationManager.stopMonitoring(for: region)
                }
                
            }
            
            return Alert(
                title: Text("You have arrived!"),
                message:
                    Text("""
          You have arrived - ready to collect your pledge points?
          """),
                primaryButton: .default(Text("Yes")),
                secondaryButton: .default(Text("No"))
            )
        }
        
    }
}


//Make location location
private func makeLocationManager() -> CLLocationManager {
    let manager = CLLocationManager()
    manager.allowsBackgroundLocationUpdates = true
    manager.startUpdatingLocation()
    return manager
}
