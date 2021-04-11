//
//  Capital.swift
//  Project-16
//
//  Created by joao camargo on 11/04/21.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
   
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String = ""
    
    internal init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
    
    
}
