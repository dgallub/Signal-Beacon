//
//  Pin.swift
//  Signal Beacon
//
//  Created by David Gallub on 11/4/17.
//  Copyright © 2017 Amatrine. All rights reserved.
//

import Foundation

//Pin class, capable of storing coordinates, picture link (future implementation), title, and subtitle for making or storing
//map annotations
class Pin{
    
    var lat: Double
    var long: Double
    var username: String
    var friends: [String]
    init(lat: Double, long: Double, username: String, friends: [String]
        ){
        self.lat = lat
        self.long = long
        self.username = username
        self.friends = friends
    }
    
    
    
    
}
