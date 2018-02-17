//
//  AddCityCell.swift
//  TheWeatherTurtle
//
//  Created by MARIO EGUILUZ ALEBICTO on 17/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import UIKit

class AddCityCell: UITableViewCell {

    @IBOutlet weak var labelCity: UILabel!

    func update(_ viewModel: City) {
        labelCity.text = viewModel.name
    }
}
