//
//  StoreService.swift
//  TheWeatherTurtle
//
//  Created by MARIO EGUILUZ ALEBICTO on 17/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import Foundation

final class DataStoreService {

    private var allCities: [City]?

    private let defaultCityIDs = ["524901", "703448", "2643743"]
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
        let cities = [keyCities: defaultCityIDs]
        NSKeyedArchiver.archiveRootObject(cities, toFile: path)
    }

    func getAllCities(completion: @escaping ([City]) -> Void) {
        if let cities = allCities {
            completion(cities)
        }

        DispatchQueue.global().async { [weak self] in
            guard let path = Bundle.main.path(forResource: "citylist", ofType: "json"),
                let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped),
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                let array = json as? [Dictionary<String,Any>] else {
                    completion([])
                    return
            }
            let cities = array.map { City.init(with: $0) }
            self?.allCities = cities
            DispatchQueue.main.async {
                completion(cities)
            }
        }
    }

    func getUserCities() -> [String] {
        guard FileManager.default.fileExists(atPath: path),
            let dictionary = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [String : [String]],
            let cities = dictionary[keyCities] else {
            return []
        }
        return cities
    }

    @discardableResult
    func storeCity(_ cityID: String) -> Bool {
        let path = self.path
        guard FileManager.default.fileExists(atPath: path),
            var dictionary = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [String : [String]],
            var cities = dictionary[keyCities],
            !cities.contains(cityID) else {
            return false
        }

        cities.append(cityID)
        dictionary[keyCities] = cities
        return NSKeyedArchiver.archiveRootObject(dictionary, toFile: path)
    }
}
