//
//  ViewState.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 12/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

enum ViewState<A> {
    case loading
    case error
    case data(viewModel: A)
    
    func isLoading() -> Bool {
        switch self {
        case .loading:
            return true
        default:
            return false
        }
    }
    
    func isError() -> Bool {
        switch self {
        case .error:
            return true
        default:
            return false
        }
    }
    
    func isData() -> Bool {
        switch self {
        case .data(_):
            return true
        default:
            return false
        }
    }
}
