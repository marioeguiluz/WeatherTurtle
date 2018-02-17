//
//  AddCityViewModel.swift
//  TheWeatherTurtle
//
//  Created by MARIO EGUILUZ ALEBICTO on 17/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

struct AddCityViewModel {
    let cityResults: [City]
    let allCities: [City]
}

extension AddCityViewModel {

    static func empty() -> AddCityViewModel {
        return AddCityViewModel(cityResults: [], allCities: [])
    }
}
