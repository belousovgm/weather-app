//
//  FirstState.swift
//  ReactiveWeather
//
//  Created by Grigory Belousov on 02.09.2022.
//

import Foundation

enum CitiesState {
    case nothing
    case loading
    case error
    case data(
        searchState: SearchState,
        citiesState: CitiesState
    )

    enum CitiesState {
        case empty
        case loading
        case loaded(cities: [City])
    }
    
    struct SearchState {
        let searchText: String
        let isSearching: Bool
    }
}


