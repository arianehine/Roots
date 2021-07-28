//
//  Chimney.swift
//  Chimney
//
//  Created by Ariane Hine on 28/07/2021.
//

import Foundation
import SwiftUI

struct Chimney: Shape{
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        
        //brown

        path.move(to: CGPoint(x: rect.midX-10, y: rect.minY+5))
        //top right
        path.addLine(to: CGPoint(x: rect.minX+10, y: rect.maxY))
        //bottom right
        //bottom left
        path.addLine(to: CGPoint(x: rect.maxX-10, y: rect.maxY))
        //top left
        path.addLine(to: CGPoint(x: rect.midX+10, y: rect.minY+5))
        path.addLine(to: CGPoint(x: rect.midX+10, y: rect.minY+5))
        //top right
       
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addArc(center: .init(x: rect.midX, y: rect.minY), radius: 4, startAngle: Angle(degrees: 0.0), endAngle: Angle(degrees: 0.2), clockwise: true)
        
        path.move(to: CGPoint(x: rect.midX+5, y: rect.minY-10))
        path.addArc(center: .init(x: rect.midX+5, y: rect.minY-10), radius: 8, startAngle: Angle(degrees: 0.0), endAngle: Angle(degrees: 0.2), clockwise: true)
        
        path.move(to: CGPoint(x: rect.midX+10, y: rect.minY-20))
        path.addArc(center: .init(x: rect.midX+1, y: rect.minY-20), radius: 12, startAngle: Angle(degrees: 0.0), endAngle: Angle(degrees: 0.2), clockwise: true)
        
        path.move(to: CGPoint(x: rect.midX+15, y: rect.minY-30))
        path.addArc(center: .init(x: rect.midX+15, y: rect.minY-30), radius: 18, startAngle: Angle(degrees: 0.0), endAngle: Angle(degrees: 0.2), clockwise: true)
        //green
        
        //oval for now
        return path
    }
}
