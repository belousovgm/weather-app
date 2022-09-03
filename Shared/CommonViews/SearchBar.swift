//
//  SearchBar.swift
//  ReactiveWeather
//
//  Created by Grigory Belousov on 03.09.2022.
//

import SwiftUI

struct SearchBar: View {
    private let placeholderText: String
    private let isSearching: Bool
    private let binding: Binding<String>
    
    init(_ placeholderText: String, isSearching: Bool, binding: Binding<String>) {
        self.placeholderText = placeholderText
        self.binding = binding
        self.isSearching = isSearching
    }
    
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(.gray.opacity(0.30))
            HStack {
                Image(systemName: "magnifyingglass")
                TextField(
                    placeholderText,
                    text: binding
                ).padding()
                
                if isSearching {
                    ProgressView()
                        .padding(.trailing, 12)
                }
            }.foregroundColor(.gray)
                .padding(.leading, 13)
        }.frame(height: 40)
            .cornerRadius(13)
            .padding()
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        var value: String = ""
        SearchBar(
            "Search...",
            isSearching: true,
            binding: Binding(
                get: { value },
                set: { value = $0 }
            )
        )
    }
}
