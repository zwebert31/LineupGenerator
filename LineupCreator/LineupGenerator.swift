//
//  LineupGenerator.swift
//  LineupCreator
//
//  Created by Zachary Webert on 9/29/15.
//  Copyright © 2015 Zachary Webert. All rights reserved.
//

import Foundation

enum ContestParseError: ErrorType {
    case CannotParseCSV
    case CannotImportCSV
}

class LineupGenerator {
    class func generate(contestRosterFile: String, salaryCap: Double = 50000) {
        do {
            //Create lineup generator object
            let generator = LineupGenerator()
            
            //import csv from file
            let csv = try generator.importCSV(contestRosterFile)
            
            //parse csv into an array of players
            let players = try generator.parseCSV(csv)
            
            let lineup = Lineup(salaryCap: salaryCap)
            try lineup.fill(players)
            
            print(lineup)
            
        } catch {
            print(error)
        }
        
        print("Hello, World!")
    }
    
    func parseCSV(csv: CSV) throws -> [Player] {
    
        var playerList: [Player] = []
        for row in csv.rows {
            var dict: [String:String] = [:]
            for cell in row {
                dict[cell.0.stringByReplacingOccurrencesOfString("\"", withString: "")] = cell.1.stringByReplacingOccurrencesOfString("\"", withString: "")
            }
            guard
                let name = dict["Name"],
                let position = Position(rawValue: dict["Position"] ?? ""),
                let salary = Double(dict["Salary"] ?? "none"),
                let value = Double(dict["AvgPointsPerGame"] ?? "none") else {
                    throw ContestParseError.CannotParseCSV
            }
            playerList.append(Player(name: name, position: position, salary: salary, value: value))
        }
        
        return playerList
    }
    
    func importCSV(fileName: String) throws -> CSV {
        var players: CSV!
        let csvString = try String(contentsOfFile: fileName)
        do {
            players = try CSV(content: csvString, delimiter: NSCharacterSet(charactersInString: ","), encoding: NSUTF8StringEncoding)
        } catch {
            throw ContestParseError.CannotImportCSV
        }
        return players
    }
}