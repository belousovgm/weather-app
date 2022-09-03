//
//  FirstStore.swift
//  ReactiveWeather
//
//  Created by Grigory Belousov on 02.09.2022.
//

import Foundation
import Combine
 
class CitiesStore: ObservableObject {
    private let citiesManager = CitiesManager()
    
    private var bag = Set<AnyCancellable>()
    
    lazy var intent: CurrentValueSubject<CitiesIntent, Never> = {
        let subject = CurrentValueSubject<CitiesIntent, Never>(.nothing)
        subject
            .removeDuplicates()
            .sink(receiveValue: accept).store(in: &bag)
        return subject
    }()
    
    
    @Published var state: CitiesState = .nothing
    
    init() {
        intent.send(.initialize)
    }

    func accept(_ intent: CitiesIntent) {
        switch intent {
        case .initialize:
            state = reduce(mutation: .loadingStarted, state: state)
            loadCities()
        case .search(let text):
            state = reduce(mutation: .searchingStarted(searchText: text), state: state)
            if text.isEmpty {
                loadCities()
            } else {
                search(text: text)
            }
        case .nothing:
            break
        }
    }
    
    private func loadCities() {
        citiesManager.getCities()
            .delay(for: 2, scheduler: DispatchQueue.main)
            .sink { [unowned self] cities in
            state = reduce(mutation: .citiesLoaded(cities: cities), state: state)
        }.store(in: &bag)
    }
    
    private func search(text: String) {
        citiesManager.search(text: text)
            .delay(for: 2, scheduler: DispatchQueue.main)
            .sink { [unowned self] cities in
            state = reduce(mutation: .citiesSearched(cities: cities, searchText: text), state: state)
        }.store(in: &bag)
    }

    private func reduce(mutation: Mutation, state: CitiesState) -> CitiesState {
        switch mutation {
        case .loadingStarted:
            return .loading
        case .citiesLoaded(let cities):
            return .data(
                searchState: CitiesState.SearchState(searchText: "", isSearching: false),
                citiesState: .loaded(cities: cities)
            )
        case .searchingStarted(let searchText):
            if case let .data(_, citiesState) = state {
                return .data(
                    searchState: CitiesState.SearchState(searchText: searchText, isSearching: true),
                    citiesState: citiesState
                )
            } else {
                fatalError("Unexpected state on mutation. Current state: \(state). Mutation \(mutation)")
            }
        case .citiesSearched(cities: let cities, searchText: let searchText):
            return .data(
                searchState: CitiesState.SearchState(searchText: searchText, isSearching: false),
                citiesState: .loaded(cities: cities)
            )
        }
    }
    
    enum Mutation {
        case citiesLoaded(cities: [City])
        case citiesSearched(cities: [City], searchText: String)
        case searchingStarted(searchText: String)
        case loadingStarted
    }
}
