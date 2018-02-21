//
//  CollectionWeatherCell.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 21/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import UIKit

final class CollectionWeatherCell: UICollectionViewCell {

    @IBOutlet weak var imageViewWeather: UIImageView!
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelDetails: UILabel!
    @IBOutlet weak var labelExtraInfo: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageViewWeather.image = nil
    }
    
    func update(_ viewModel: WeatherViewModel, mode: CollectionWeatherMode) {
        labelDetails.isHidden = mode == .collapsed
        labelExtraInfo.isHidden = mode == .collapsed
        
        labelCity.text = viewModel.city
        labelTemperature.text = viewModel.temperature
        labelDetails.text = viewModel.detail
        labelExtraInfo.text = "50% humidity"
        ImageDownloader.shared.setImage(from: viewModel.icon, completion: { [weak self] (image) in
            self?.imageViewWeather.image = image
        })
    }
}
