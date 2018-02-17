//
//  Sys.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 07/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

struct Sys: Codable {
	let type: Int?
	let id: Int?
	let message: Double?
	let country: String?
	let sunrise: Int?
	let sunset: Int?
}
