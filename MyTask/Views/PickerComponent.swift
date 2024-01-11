//
//  PickerComponent.swift
//  MyTask
//
//  Created by Vikas Kumar on 10/12/23.
//

import SwiftUI

struct PickerComponent: View {
    @State private var pickerFilters: [String] = ["Active", "Closed"]
    @Binding var defaultPickerSelectedItem: String
    
    var body: some View {
        Picker("Picker Filter", selection: $defaultPickerSelectedItem) {
            ForEach(pickerFilters, id: \.self) {
                Text($0)
            }
        }
        .padding(.horizontal, 20)
        .pickerStyle(.segmented)
    }
}

struct PickerComponent_Previews: PreviewProvider {
    static var previews: some View {
        PickerComponent(defaultPickerSelectedItem: .constant("Active"))
    }
}
