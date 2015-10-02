//
//  main.swift
//  LineupCreator
//
//  Created by Zachary Webert on 9/29/15.
//  Copyright © 2015 Zachary Webert. All rights reserved.
//

import Foundation

if Process.argc >= 2 {
   LineupGenerator.generate(Process.arguments[1])
} else {
    assertionFailure("No contest roster was passed")
}

