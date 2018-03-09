//
//  Navigable.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 10/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import UIKit

protocol Navigable: ErrorPresenter {
    var appPresentationManager: AppPresentationManager { get }
}

final class Navigator: Navigable  {
    let appPresentationManager: AppPresentationManager
    
    init(appPresentationManager: AppPresentationManager) {
        self.appPresentationManager = appPresentationManager
    }
}
