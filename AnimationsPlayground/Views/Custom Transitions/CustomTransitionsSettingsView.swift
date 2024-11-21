//
//  CustomTransitionsSettingsView.swift
//  AnimationsPlayground
//
//  Created by Fernando Draghi on 21/11/2024.
//

import SwiftUI

struct CustomTransitionsSettingsView: View {
    @State private var repeatAlarmSelection = 1
    @State private var setDate = Date()
    @State private var timezoneOverride = false
    @State private var volume: Double = 0.0
    @Binding var show: Bool

    var body: some View {
        ZStack {
            NavigationView {
                List {
                    Section(header: Text("Date and time")) {
                        DatePicker(selection: $setDate, label: {
                            Image(systemName: "calendar.circle")
                        })
                        .colorScheme(.light)
                        .foregroundStyle(.black)
                    }
                    .listRowBackground(Color(.mint))
                    
                    Section(header: Text("Time Zone Override")) {
                        Toggle(isOn: $timezoneOverride) {
                            HStack {
                                Image(systemName: "clock")
                                Text("Override")
                            }
                            .foregroundStyle(.black)
                        }
                        .tint(.black)
                        .colorScheme(.light)
                        
                    }
                    .listRowBackground(Color(.mint))
                    
                    Section(header: Text("Alarm Volume")) {
                        Text("Volume: \(String(format: "%.2f", volume))")
                            .foregroundStyle(.black)
                        Slider(value: $volume, in: 0...11, step: 0.25)
                            .tint(.black)
                            .colorScheme(.light)
                    }
                    .listRowBackground(Color(.mint))
                    
                    Section(header: Text("Repeat Alarm")) {
                        Picker(selection: $repeatAlarmSelection, label: Text("Repeat Alarm:")) {
                            Text("Never").tag(0)
                            Text("Every Day").tag(1)
                            Text("Every Week").tag(2)
                            Text("Every Month").tag(3)
                            Text("Every Year").tag(4)
                        }
                        .colorScheme(.light)
                        .foregroundStyle(.black)
                    }
                    .listRowBackground(Color(.mint))
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            self.show = false
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text("Save")
                                .foregroundStyle(.black)
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.white)
                }
                .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                .scrollContentBackground(.hidden)
                .navigationTitle("Settings")
            }
            .frame(width: 350, height: 650)
            .clipShape(.rect(cornerRadius: 20))
            
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    CustomTransitionsSettingsView(show: .constant(false))
}
