//
//  DictPin.swift
//  Signal Beacon
//
//  Created by David Gallub on 11/4/17.
//  Copyright © 2017 Amatrine. All rights reserved.
//

import Foundation
/Users/thomasshealy/Desktop/Signal-Beacon/Signal Beacon/DictPin.swift
class DictPin{
    var pinLat: Double!
    var pinLong: Double!
    var pinUsername: String!
    var friends: [String]!
    
    var pinKey: String!
    
    init(key: String, dictionary: Dictionary<String, AnyObject>){
        
        self.pinKey = key
        
        if let lat = dictionary["lat"] as? Double{
            self.pinLat = lat
        }
        if let long = dictionary["long"] as? Double{
            self.pinLong = long
        }
        if let username = dictionary["username"] as? String{
            self.pinUsername = username
        }
        if let friends = dictionary["friends"] as? [String]{
            self.friends = friends
        }
   
    }
}
