//
//  PeriodicElemestsStructures.swift
//  SwiftyProteins
//
//  Created by Михаил Фокин on 10.02.2021.
//  Copyright © 2021 home. All rights reserved.
//

import Foundation

// MARK: - PeriodicElemestsStructures
struct PeriodicElemestsStructures: Codable {
    let elements: [Element]
}

// MARK: - Element
struct Element: Codable {
    let name: String
    let atomicMass: Double?
    let boil: Double?
    let density: Double?
    let melt: Double?
    let symbol: String
    let electronConfiguration: String

    enum CodingKeys: String, CodingKey {
        case name
        case atomicMass = "atomic_mass"
        case boil, density
        case melt
        case symbol
        case electronConfiguration = "electron_configuration"
    }
}
