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
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        MenuBarExtra("FelizeterApp", image: "TRex") {
            AppMenu()
                .environmentObject(appDelegate)
        }
    }
}

struct AppMenu: View {
    @EnvironmentObject var appDelegate: AppDelegate
    @State private var textOutput = "No Action Taken Yet"

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
            Text("Key Press Count: \(appDelegate.keyPressCount)") // Add this line
                .padding()
            
            Text(textOutput)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Text(AXIsProcessTrusted() == true ? "true" : "false")
            
            Button(action: action1, label: { Text("Action 1") })
            Button(action: action2, label: { Text("Action 2") })
            
            Divider()

            Toggle(isOn: $appDelegate.isOn) {
                Text(appDelegate.isOn ? "Turn OFF" : "Turn ON")
            }
            
            Divider()
            
            Button(action: action3, label: { Text("Exit") })
        }
    }
}


