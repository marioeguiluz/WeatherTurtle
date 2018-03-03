//
//  ErrorPresenter.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 03/03/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import UIKit

protocol ErrorPresenter {
    func alertGeneralError() -> UIAlertController
}

extension ErrorPresenter {
    func alertGeneralError() -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: "General issue", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        return alert
    }
}
