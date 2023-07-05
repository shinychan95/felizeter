//
//  felizeterApp.swift
//  felizeter
//
//  Created by USER on 2023/07/05.
//

import SwiftUI
import Foundation

@main
struct felizeterApp: App {
    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true
    @NSApplicationDelegateAdaptor private var appDelegate: MyAppDelegate
    
    var body: some Scene {
        MenuBarExtra("FelizeterApp", image: "TRex") {
            AppMenu()
                .environmentObject(appDelegate)
        }
    }
}

struct AppMenu: View {
    @EnvironmentObject var appDelegate: MyAppDelegate
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
            Text("Key Press Count: \(appDelegate.keyPressCount)") // Add this line
                .padding()
            
            Text(textOutput)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Text(AXIsProcessTrusted() == true ? "true" : "false")
            
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

class MyAppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    var monitor: Any?
    @Published var keyPressCount = 0
    
    func applicationDidFinishLaunching(
        _ application: NSApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        // Record the device token.
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("Application did finish launching")
        self.keyPressCount += 1
        monitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
            print("Key pressed: \(event.keyCode)")
            self.keyPressCount += 1
        }
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        if let monitor = monitor {
            NSEvent.removeMonitor(monitor)
        }
    }
}
