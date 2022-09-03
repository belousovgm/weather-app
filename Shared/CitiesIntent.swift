//
//  FirstIntent.swift
//  ReactiveWeather
//
//  Created by Grigory Belousov on 02.09.2022.
//

import Foundation

enum CitiesIntent: Equatable {
    case nothing
    case initialize
    case search(text: String)
}
