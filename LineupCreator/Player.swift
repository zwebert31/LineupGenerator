//
//  Player.swift
//  LineupCreator
//
//  Created by Zachary Webert on 9/29/15.
//  Copyright © 2015 Zachary Webert. All rights reserved.
//

import Foundation

enum Position: String {
    case RB = "RB"
    case WR = "WR"
    case QB = "QB"
    case DST = "DST"
    case TE = "TE"
    case FLEX = "FLEX"
}
class Player: NSObject {
    var name: String!
    var position: Position!
    var salary: Double!
    var value: Double!
    
    var ratio: Double {
        return value/salary
    }
    
    func isPosition(position: Position) -> Bool {
        return position == .FLEX ? (self.position == .RB || self.position == .WR || self.position == .TE) : self.position == position
    }
    
    required init(name: String, position: Position, salary: Double, value: Double){
        super.init()
        self.name = name
        self.position = position
        self.salary = salary
        self.value = value
    }
    
    override var description: String {
        let positionString = "\(position)".stringByPaddingToLength(4, withString: " ", startingAtIndex: 0)
        
        let nameString = "\(name)".stringByPaddingToLength(17, withString: " ", startingAtIndex: 0)
        
        let valueString = "\(value)".stringByPaddingToLength(7, withString: " ", startingAtIndex: 0)
        
        let salaryString = "\(salary)".stringByPaddingToLength(7, withString: " ", startingAtIndex: 0)
        
        
        return "\(positionString) - \(nameString) - \(valueString) - \(salaryString)"
    }
}