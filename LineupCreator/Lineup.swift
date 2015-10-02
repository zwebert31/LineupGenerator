//
//  Lineup.swift
//  LineupCreator
//
//  Created by Zachary Webert on 9/30/15.
//  Copyright © 2015 Zachary Webert. All rights reserved.
//
import Foundation

enum LineupError: ErrorType {
    case CannotFillPosition
    case CannotUpgradePosition
    case CannotDowngradePosition
}

class Lineup: NSObject {
    private var salaryCap: Double = 50000
    
    var remainingSalary: Double {
        return players.reduce(salaryCap, combine: { (remaining, p) -> Double in
            return remaining - p.salary
        })
    }
    let roster = [
        (position: Position.RB, available: 2),
        (position: Position.WR, available: 3),
        (position: Position.QB, available: 1),
        (position: Position.TE, available: 1),
        (position: Position.DST, available: 1),
        (position: Position.FLEX, available: 1),
    ]
    
    var players: [Player] = []
    
    required init(salaryCap: Double) {
        super.init()
        self.salaryCap = salaryCap
    }
    
    func fill(playerList: [Player]) throws {
        var list = playerList
        list.sortInPlace({ (p1, p2) -> Bool in
            return p1.ratio > p2.ratio
        })
        
        for rosterPosition in roster {
            let positionList = list.filter({ (player) -> Bool in
                return player.isPosition(rosterPosition.position)
            })
            
            if positionList.count < rosterPosition.available {
                throw LineupError.CannotFillPosition
            }
            
            for i in 0..<rosterPosition.available {
                let player = positionList[i]
                
                list.removeAtIndex(list.indexOf(player)!)
                player.position = rosterPosition.position
                self.players.append(player)
            }
        }
        
        //self.optimizeCost(list)
    }
    
    func optimizeCost(playerList: [Player], threshold: Double = 5000) {
        var list = playerList
        var currentList = self.players
        let salaryRemaining = self.remainingSalary
        if salaryRemaining < 0 {
            print(salaryRemaining)
        } else if salaryRemaining > 0 {
            currentList.sortInPlace({ (p1, p2) -> Bool in
                return p1.ratio < p2.ratio
            })
            list.sortInPlace({ (p1, p2) -> Bool in
                return p1.value > p2.value
            })
            
            var rosterIndex = 0

            //Loop through players in order of worst to best ratio until remaining salary is acceptable or we have upgraded every player
            while salaryRemaining > threshold || rosterIndex > currentList.count {
                let worstPlayer = currentList[rosterIndex]
                let positionList = list.filter({ (p) -> Bool in
                    p.isPosition(worstPlayer.position)
                })
                
                do {
                   let newPlayer = try upgradePlayer(worstPlayer, playerList: positionList)
                    currentList[rosterIndex] = newPlayer
                } catch {
                    print("Attempted to upgrade \(worstPlayer.name).  Can not upgrade.")
                }
                rosterIndex++
            }
        }
    }
    
    func upgradePlayer(player: Player, playerList: [Player]) throws -> Player {
        throw LineupError.CannotUpgradePosition
    }
    
    func downgradePlayer(player: Player, playerList: [Player]) throws -> Player {
        throw LineupError.CannotDowngradePosition
    }
    
    
    override var description: String {
        var description = ""
        for p in self.players {
            description += "\(p)\n"
        }
        description += "Salary Remaining: \(self.remainingSalary)\n"
        
        return description
    }
    
}
