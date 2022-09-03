//
//  ContentView.swift
//  ReactiveWeather
//
//  Created by Grigory Belousov on 02.09.2022.
//

import SwiftUI
import Combine

struct CitiesView: View {
    @ObservedObject var store: CitiesStore = CitiesStore()

    
    var body: some View {
        switch store.state {
        case .loading:
            ProgressView()
        case let .data(searchState: searchState, citiesState: citiesState):
            VStack {
                SearchBar(
                    "Search...",
                    isSearching: searchState.isSearching,
                    binding: bind(
                        initialValue: searchState.searchText,
                        subject: store.intent,
                        transform: { text in CitiesIntent.search(text: text) })
                )
                
                switch citiesState {
                case .empty:
                    Text("You don't have saved cities")
                case let .loaded(cities: cities):
                    List(cities) { city in
                        Text(city.name)
                    }
                case .loading:
                    Text("Loading")
                }
            }
        default:
            Text("Default")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CitiesView()
    }
}

func bind<T: Any, R: Any>(initialValue: T, subject: CurrentValueSubject<R, Never>, transform: @escaping (T) -> R) -> Binding<T> {
    var value = initialValue
    var initial = 0
    return Binding(
        get: { value },
        set: {
            if initial < 1 {
                initial+=1
            } else {
                subject.send(transform($0))
            }
            
            value = $0
        }
    )
}
