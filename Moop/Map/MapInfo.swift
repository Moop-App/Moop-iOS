//
//  MapInfo.swift
//  Moop
//
//  Created by kor45cw on 31/07/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Foundation
import MapKit

struct MapInfo: Decodable {
    let cgv: CodeGroup
    let lotte: CodeGroup
    let megabox: CodeGroup
    
    var items: [Theater] {
        let cgvList = cgv.list.flatMap({ $0.theaterList })
        let lotteList = lotte.list.flatMap({ $0.theaterList })
        let megaboxList = megabox.list.flatMap({ $0.theaterList })
        return cgvList + lotteList + megaboxList
    }
}

struct CodeGroup: Decodable {
    let list: [AreaGroup]
}

struct AreaGroup: Decodable {
    let area: Area
    let theaterList: [Theater]
}

struct Area: Decodable {
    let code: String
    let name: String
}

class Theater: NSObject, Decodable, MKAnnotation {
    let type: String
    let code: String
    let name: String
    let lng: Double
    let lat: Double
    
    var theaterType: TheaterType {
        return TheaterType(type: type)
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
    
    var title: String? {
        return "\(name) \(theaterType.title)"
    }
    
    var destinationName: String {
        let dname = "도착지".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return title?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? dname
    }
    
    var mapItem: MKMapItem {
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
    
//    var subtitle: String? {
//        return name
//    }
}
