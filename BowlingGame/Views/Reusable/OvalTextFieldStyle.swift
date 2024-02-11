//
//  OvalTextFieldStyle.swift
//  BowlingGame
//
//  Created by Julia Ajhar on 2/9/24.
//

import SwiftUI

struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(.white)
            .cornerRadius(20)
            .shadow(color: .gray.opacity(0.3), radius: 3)
    }
}
