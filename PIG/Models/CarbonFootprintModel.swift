//
//  CarbonFootprintModel.swift
//  CarbonFootprintModel
//
//  Created by Ariane Hine on 31/07/2021.
//

import Foundation
class CarbonFootprint{

    var travelPledgeConstant = 0.1
    var healthPledgeConstant = 0.05
    var foodPledgeConstant = 0.08
    var householdPledgeConstant = 0.12
    var fashionPledgeConstant = 0.06
    
    func getConstant(area: String) -> Double{
        if(area == "Transport"){
            return travelPledgeConstant
        } else if(area == "Household"){
            return householdPledgeConstant
    }else if(area == "Health"){
        return healthPledgeConstant
}else if(area == "Fashion"){
    return fashionPledgeConstant
}
else if(area == "Food"){
    return foodPledgeConstant
}

        return 0.01
}
}
    


   
