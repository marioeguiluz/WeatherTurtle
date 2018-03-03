//
//  Navigable.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 10/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import UIKit

protocol Navigable: ErrorPresenter {
    var routerManager: RouterManager { get }
}

final class Navigator: Navigable  {
    let routerManager: RouterManager
    
    init(routerManager: RouterManager) {
        self.routerManager = routerManager
    }
}
