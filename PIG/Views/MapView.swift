//
//  MapView.swift
//  PIG
//
//  Created by ariane hine on 01/07/2021.
//

import SwiftUI
import CoreLocation
//Inspired by //https://kavsoft.dev/SwiftUI_2.0/Advance_MapKit
//Shows the map and manages the format it is displayed in (e.g search bar at top)
struct MapView: View {
    
    @StateObject var mapData = MapViewModel()
    @Binding var completed: Bool
    // Location Manager....
    @Binding var showingModal: Bool
    @State var locationManager = makeLocationManager()
    
    var body: some View {
        
        ZStack{
            
            // MapView...
            MapShower()
            // using it as environment object so that it can be used ints subViews....
                .environmentObject(mapData)
                .ignoresSafeArea(.all, edges: .all)
            
            VStack{
                //Show search bar
                VStack(spacing: 0){
                    HStack{
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search", text: $mapData.searchTxt)
                            .colorScheme(.light)
                    }
                    .padding(.vertical,10)
                    .padding(.horizontal)
                    .background(Color.white)
                    
                    // Displaying Results of query
                    
                    if !mapData.places.isEmpty && mapData.searchTxt != ""{
                        
                        ScrollView{
                            
                            VStack(spacing: 15){
                                
                                ForEach(mapData.places){place in
                                    
                                    Text(place.placemark.name ?? "")
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity,alignment: .leading)
                                        .padding(.leading)
                                        .onTapGesture{
                                            
                                            mapData.selectPlace(place: place)
                                        }
                                    
                                    Divider()
                                }
                            }
                            .padding(.top)
                        }
                        .background(Color.white)
                    }
                    
                }
                .padding()
                
                Spacer()
                
                VStack{
                    
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
                        Text("Quit tracking pledge?").frame(height: 20)
                        
                    }.background(Color.white)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
            }
            
        }.alert(isPresented: $mapData.didArriveAtDestination) {
            
            
            
            for region in locationManager.monitoredRegions {
                locationManager.stopMonitoring(for: region)
            }
            
            completed = true
            showingModal = false
            
            //Display alert when user arrives at destination (i.e. enters monitored region)
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
        
        
        .onAppear(perform: {
            
            // Setting Delegate.
            locationManager.delegate = mapData
            locationManager.requestWhenInUseAuthorization()
            
            
        })
        // Permission Denied Alert
        .alert(isPresented: $mapData.permissionDenied, content: {
            
            Alert(title: Text("Permission Denied"), message: Text("Please Enable Permission In App Settings"), dismissButton: .default(Text("Goto Settings"), action: {
                
                // Redireting User To Settings...
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
        })
        .onChange(of: mapData.searchTxt, perform: { value in
            
            // Searching Places
            // Delay to avoid Continous Search Request
            let delay = 0.3
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                
                if value == mapData.searchTxt{
                    
                    // Search...
                    self.mapData.searchQuery()
                }
            }
        })
    }
}
//Make the location manager
private func makeLocationManager() -> CLLocationManager {
    
    let manager = CLLocationManager()
    manager.allowsBackgroundLocationUpdates = true
    
    manager.startUpdatingLocation()
    return manager
}
