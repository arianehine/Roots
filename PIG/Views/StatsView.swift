//
//  StatsView.swift
//  PIG
//
//  Created by ariane hine on 17/05/2021.
//

import SwiftUI
import Charts


//Shows the bar graph with the user's carbon footprint
//Chimney shaped bars are red if over the UK average per day, or green if under
struct StatsView: View {
    @State var ID: String
    @EnvironmentObject var statsController: StatsDataController
    @EnvironmentObject var viewModel: AppViewModel
    @State var average: String = "not defined"
    @State var ltOrGt: String = "not defined"
    @State var people = [UserData]()
    @State var color = 0;
    @State var averageInKg: Double = 0;
    @State var reports: [Report] = [Report]();
    @State var originalReports: [Report] = [Report]();
    @State var originalPeople : [UserData]
    @Binding var fbLogic: FirebaseLogic
    @State var selection: String
    
    var body: some View {
        
        //Displays the bar graph
        BarGraphView(selection: $selection, reports: $reports, originalReports: $originalReports).environmentObject(statsController).onAppear{
            
            if (statsController.originalPeople.count == 0) {
                people = originalPeople;
            } else{
                people = originalPeople;
            }
            let user = statsController.findUserData(people: people, ID: viewModel.footprint);
            
            self.originalReports = statsController.convertToReports(users: user);
            
        }.onChange(of: viewModel.footprint){ value in
            self.ID = value
            let user = statsController.findUserData(people: people, ID: ID);
            
            
            self.originalReports = statsController.convertToReports(users: user);
        }
        .onChange(of: statsController.originalPeople) {value in
            
            people = statsController.originalPeople;
            let user = statsController.findUserData(people: people, ID: viewModel.footprint);
            self.originalReports = statsController.convertToReports(users: user);
            
        }
        .onChange(of: statsController.fbLogic.userData) {value in
            
            var user = value
            self.people = statsController.fbLogic.userData
            
            
            self.originalReports = statsController.convertToReports(users: user);
            
        }.onAppear(){
            if(statsController.fbLogic.userData.count != 0){
                
                people = statsController.fbLogic.userData
                
            }
            
            else{
                
                people = statsController.originalPeople
            }
            
            
            let user = statsController.findUserData(people: people, ID: viewModel.footprint);
            
            self.originalReports = statsController.convertToReports(users: user);
        }
        
        
    }
    
    
    //Sets the colour of the text according to UK average
    func textColour(gtOrLt: String) -> Color
    {
        if(gtOrLt == "greater than" )
        {
            return Color.red;
        }
        else if( gtOrLt == "less than" )
        {
            return Color.green;
        }
        else
        {
            return Color.gray;
        }
    }
    
    
}

