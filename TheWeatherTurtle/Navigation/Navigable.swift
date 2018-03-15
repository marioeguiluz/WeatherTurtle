//
//  Navigable.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 10/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import UIKit

protocol Navigable {

    var appPresentationManager: AppPresentationManager { get }

    func pop()
    func dismiss()
    func showAlertGeneralError()
    func showAlertSuccess(title: String, message: String, completion: @escaping () -> ())
}

extension Navigable {

    func pop() {
        appPresentationManager.rootNavController()?.popViewController(animated: true)
    }

    func dismiss() {
        appPresentationManager.selectedViewController().dismiss(animated: true, completion: nil)
    }

    func showAlertGeneralError() {
        let alert = UIAlertController(title: "Error", message: "General issue", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        appPresentationManager.selectedViewController().present(alert, animated: true, completion: nil)
    }

    func showAlertSuccess(title: String, message: String, completion: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            completion()
        }
        alert.addAction(action)
        appPresentationManager.selectedViewController().present(alert, animated: true, completion: nil)
    }
}

final class Navigator: Navigable  {
    let appPresentationManager: AppPresentationManager

    init(appPresentationManager: AppPresentationManager) {
        self.appPresentationManager = appPresentationManager
    }
}

