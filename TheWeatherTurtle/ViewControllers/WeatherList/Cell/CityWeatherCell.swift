//
//  CityWeatherCell.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 12/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import UIKit

final class CityWeatherCell: UITableViewCell {

    @IBOutlet weak var imageViewWeather: UIImageView!
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var labelTemperature: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageViewWeather.image = nil
    }
    
    func update(_ viewModel: WeatherViewModel) {
        labelCity.text = viewModel.city
        labelTemperature.text = viewModel.temperature
        contentView.backgroundColor = viewModel.temperatureCategory.backgroundColor()
        ImageDownloader.shared.setImage(from: viewModel.icon, completion: { [weak self] (image) in
            self?.imageViewWeather.image = image
        })
    }
}
