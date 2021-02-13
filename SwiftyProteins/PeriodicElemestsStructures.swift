//
//  PeriodicElemestsStructures.swift
//  SwiftyProteins
//
//  Created by Михаил Фокин on 10.02.2021.
//  Copyright © 2021 home. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let periodicElemestsStructures = try? newJSONDecoder().decode(PeriodicElemestsStructures.self, from: jsonData)

import Foundation

// MARK: - PeriodicElemestsStructures
struct PeriodicElemestsStructures: Codable {
    let elements: [Element]
}

// MARK: - Element
struct Element: Codable {
    let name: String
    let appearance: String?
    let atomicMass: Double?
    let boil: Double?
    let category: String
    let color: String?
    let density: Double?
    let discoveredBy: String?
    let melt, molarHeat: Double?
    let namedBy: String?
    let number, period: Int
    let phase: Phase
    let source: String
    let spectralImg: String?
    let summary, symbol: String
    let xpos, ypos: Int
    let shells: [Int]
    let electronConfiguration, electronConfigurationSemantic: String
    let electronAffinity, electronegativityPauling: Double?
    let ionizationEnergies: [Double]
    let cpkHex: String?

    enum CodingKeys: String, CodingKey {
        case name, appearance
        case atomicMass = "atomic_mass"
        case boil, category, color, density
        case discoveredBy = "discovered_by"
        case melt
        case molarHeat = "molar_heat"
        case namedBy = "named_by"
        case number, period, phase, source
        case spectralImg = "spectral_img"
        case summary, symbol, xpos, ypos, shells
        case electronConfiguration = "electron_configuration"
        case electronConfigurationSemantic = "electron_configuration_semantic"
        case electronAffinity = "electron_affinity"
        case electronegativityPauling = "electronegativity_pauling"
        case ionizationEnergies = "ionization_energies"
        case cpkHex = "cpk-hex"
    }
}

enum Phase: String, Codable {
    case gas = "Gas"
    case liquid = "Liquid"
    case solid = "Solid"
}
