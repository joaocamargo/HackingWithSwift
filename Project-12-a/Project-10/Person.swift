//
//  Person.swift
//  Project-10
//
//  Created by joao camargo on 27/03/21.
//

import UIKit

class Person: NSObject, NSCoding {
    
    func encode(with coder: NSCoder) {
        coder.encode(name,forKey: "name")
        coder.encode(image,forKey: "image")
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        image = coder.decodeObject(forKey: "image") as? String ?? ""
    }
    
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    var name: String
    var image: String
    
    
    
}
