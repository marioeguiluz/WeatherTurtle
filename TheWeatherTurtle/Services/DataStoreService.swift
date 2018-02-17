//
//  StoreService.swift
//  TheWeatherTurtle
//
//  Created by MARIO EGUILUZ ALEBICTO on 17/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import Foundation

final class DataStoreService {

    private let defaultCities = ["London", "Moscow", "Paris"]
    private let keyCities = "cities"

    private let filename = "dictionary.dat"
    private var path: String {
        let dirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return dirURL.appendingPathComponent(filename).path
    }

    init() {
        guard FileManager.default.fileExists(atPath: path) else {
            createInitialCities()
            return
        }
    }

    private func createInitialCities() {
        let cities = [keyCities: defaultCities]
        NSKeyedArchiver.archiveRootObject(cities, toFile: path)
    }

    func getCities() -> [String] {
        guard FileManager.default.fileExists(atPath: path),
            let dictionary = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [String : [String]],
            let cities = dictionary[keyCities] else {
            return []
        }
        return cities
    }

    @discardableResult
    func storeCity(_ city: String) -> Bool {
        let path = self.path
        guard FileManager.default.fileExists(atPath: path),
            var dictionary = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [String : [String]],
            var cities = dictionary[keyCities],
            !cities.contains(city) else {
            return false
        }

        cities.append(city)
        dictionary[keyCities] = cities
        return NSKeyedArchiver.archiveRootObject(dictionary, toFile: path)
    }
}
