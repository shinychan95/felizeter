//
//  felizeterApp.swift
//  felizeter
//
//  Created by USER on 2023/07/05.
//

import SwiftUI

@main
struct felizeterApp: App {
    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true
    
    var body: some Scene {
        MenuBarExtra("FelizeterApp", image: "TRex") {
            AppMenu()
        }
    }
}

struct AppMenu: View {
    @State private var textOutput = "No Action Taken Yet"
    @State private var isOn = false

    func action1() {
        textOutput = "Action 1 Performed"
        print(textOutput)
    }
    
    func action2() {
        textOutput = "Action 2 Performed"
        print(textOutput)
    }
    
    func action3() {
        exit(0)
    }

    var body: some View {
        VStack {
            Text(textOutput)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Button(action: action1, label: { Text("Action 1") })
            Button(action: action2, label: { Text("Action 2") })
            
            Divider()

            Toggle(isOn: $isOn) {
                Text(isOn ? "Turn OFF" : "Turn ON")
            }
            .onChange(of: isOn) { newValue in
                if newValue {
                    print("ON, start measuring system metrics...")
                    // Insert code here to start measuring system metrics
                } else {
                    print("OFF, stop measuring system metrics...")
                    // Insert code here to stop measuring system metrics
                }
            }
            
            Divider()
            
            Button(action: action3, label: { Text("Exit") })
        }
    }
}
