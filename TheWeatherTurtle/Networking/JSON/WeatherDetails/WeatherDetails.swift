//
//  WeatherDetails.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 07/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

struct WeatherDetails: Codable {
	let coord: Coord?
	let weather: [Weather]?
	let base: String?
	let main: Main?
	let visibility: Int?
	let wind: Wind?
	let clouds: Clouds?
	let dt: Int?
	let sys: Sys?
	let id: Int?
	let name: String?
	let cod: Int?
}

extension WeatherDetails {
    static func exampleData() -> WeatherDetails {
        let coord = Coord(lon: -0.13, lat: 51.51)
        let weather = [Weather(id: 601, main: "snow", description: "snow", icon: "13n")]
        let base = "stations"
        let main = Main(temp: 12, pressure: 1011, humidity: 87, temp_min: 10, temp_max: 15)
        let visibility = 8000
        let wind = Wind(speed: 2.6, deg: 40)
        let clouds = Clouds(all: 75)
        let dt = 1521397200
        let sys = Sys(type: 1, id: 5091, message: 0.0044, country: "GB", sunrise: 1521353178, sunset: 1521396681)
        let id = 2643743
        let name = "London"
        let cod = 200
        
        return WeatherDetails(coord: coord, weather: weather, base: base, main: main, visibility: visibility, wind: wind, clouds: clouds, dt: dt, sys: sys, id: id, name: name, cod: cod)
    }
}
