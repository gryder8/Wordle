//
//  SettingsView.swift
//  Wordle
//
//  Created by Gavin Ryder on 3/27/22.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var hintsEnabled: Bool
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .frame(width: 125, height: 5, alignment: .center)
                .foregroundColor(.gray)
                .padding(.bottom, 5)
            Text("Settings")
                .font(.system(size: 30, weight: .semibold, design: .rounded))
                .underline()
            
            Toggle(isOn: $hintsEnabled) {
                Text("Hints")
                    .font(.system(size: 22, weight: .regular, design: .rounded))
            }
                .padding(.horizontal, 100)
            Spacer()
        }
        .padding(.top, 30) //because this view will be shown from a popover
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(hintsEnabled: Binding.constant(true))
    }
}
