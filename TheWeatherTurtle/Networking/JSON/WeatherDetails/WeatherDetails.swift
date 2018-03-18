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
        let coord = Coord(lon: 12, lat: 12)
        let weather = [Weather(id: 1, main: "main", description: "description", icon: "10d")]
        let base = "base"
        let main = Main(temp: 12, pressure: 1, humidity: 1, temp_min: 10, temp_max: 15)
        let visibility = 1
        let wind = Wind(speed: 10, deg: 15)
        let clouds = Clouds(all: 5)
        let dt = 1
        let sys = Sys(type: 1, id: 1, message: 1, country: "GB", sunrise: 6, sunset: 18)
        let id = 1
        let name = "London"
        let cod = 1
        
        return WeatherDetails(coord: coord, weather: weather, base: base, main: main, visibility: visibility, wind: wind, clouds: clouds, dt: dt, sys: sys, id: id, name: name, cod: cod)
    }
}
