//
//  Navigable.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 10/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import UIKit

protocol Navigable {
    func alertGeneralError() -> UIAlertController
}

extension Navigable {
    func alertGeneralError() -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: "General issue", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        return alert
    }
}
