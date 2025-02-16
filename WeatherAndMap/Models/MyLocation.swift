//
//  MyLocation.swift
//  WeatherAndMap
//
//  Created by 沖野匠吾 on 2025/02/16.
//

import CoreLocation

struct MyLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
