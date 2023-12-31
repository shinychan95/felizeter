//
//  AppDelegate.swift
//  felizeter
//
//  Created by USER on 2023/07/07.
//

import SwiftUI
import Combine

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    var monitor: Any?
    var timer: Timer?
    var monitoringStartTime: Date?
    @Published var keyPressCount = 0
    @Published var isOn = false
    
    private var cancellables = Set<AnyCancellable>()

    override init() {
        super.init()

        $isOn
            .sink { [unowned self] in
                if $0 {
                    self.startMonitoringAndRecording()
                } else {
                    self.stopMonitoringAndRecording()
                }
            }
            .store(in: &cancellables)
    }
    
    func startMonitoringAndRecording() {
        print("Start monitoring and recording...")
        
        monitoringStartTime = Date()
        
        // Start monitoring
        monitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
            print("Key pressed: \(event.keyCode)")
            self.keyPressCount += 1
        }
        
        // Start recording
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { timer in
            print("Typing count for last minute: \(self.keyPressCount)")
            DBManager.shared.insertKeyPress(timeStamp: Date(), keyPressCount: self.keyPressCount)
            self.keyPressCount = 0  // Reset count for next minute
        }
    }
    
    func stopMonitoringAndRecording() {
        guard monitor != nil else {
            return
        }
        
        print("Stop monitoring and recording...")
        
        // Stop monitoring
        if let monitor = monitor {
            NSEvent.removeMonitor(monitor)
            self.monitor = nil
        }
        
        // Stop recording
        timer?.invalidate()
        timer = nil
        
        // Fetch and print all data
        let rows = DBManager.shared.fetchKeyPresses(from: monitoringStartTime)
        for row in rows {
            print("Time: \(String(describing: row["timeStamp"])), Count: \(String(describing: row["keyPressCount"]))")
        }
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("Application did finish launching")
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        stopMonitoringAndRecording()
    }
}
