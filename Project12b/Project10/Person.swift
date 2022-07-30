//
//  Person.swift
//  Project10
//
//  Created by Sergii Miroshnichenko on 16.06.2022.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }

}
