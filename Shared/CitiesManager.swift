//
//  CitiesManager.swift
//  ReactiveWeather
//
//  Created by Grigory Belousov on 02.09.2022.
//

import Foundation
import Network
import Combine

class CitiesManager {
    private let cities = ["Novosibirsk", "Moscow", "Kazan", "Saint-Petersburg", "Omsk"]
    
    func getCities() -> Publishers.Sequence<[[City]], Never> {
        return [cities.map { City(name: $0) }].publisher
    }
    
    func search(text: String) -> Publishers.Sequence<[[City]], Never> {
        return [cities.filter { $0.contains(text) }.map { City(name: $0) }].publisher
    }
}
