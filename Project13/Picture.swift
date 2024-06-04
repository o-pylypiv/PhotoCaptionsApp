//
//  Picture.swift
//  Project13
//
//  Created by Olha Pylypiv on 20.03.2024.
//

import UIKit

class Picture: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
