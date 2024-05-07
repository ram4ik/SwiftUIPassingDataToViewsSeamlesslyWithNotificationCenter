//
//  ContentView.swift
//  SwiftUIPassingDataToViewsSeamlesslyWithNotificationCenter
//
//  Created by Ramill Ibragimov on 5/3/24.
//

import SwiftUI

struct ContentView: View {
    @State private var systemNotification = SystemNotificationExample()
    
    var body: some View {
        var layout = systemNotification.orientation == .portrait ? AnyLayout(VStackLayout()) : AnyLayout(HStackLayout())
        
        NavigationStack {
            VStack {
                ReceiverView()
                SenderView()
            }
            .navigationTitle("Passing data to Views")
            .onChange(of: systemNotification.orientation) { oldValue, newValue in
                print(oldValue, " -> ", newValue)
            }
        }
    }
}

struct ReceiverView: View {
    @State private var counter = 0
    @State private var additionalInfo = ""
    
    var body: some View {
        ZStack {
            Color.mint.opacity(0.2)
            VStack {
                Text("Received **\(counter)** notifications.")
                if !additionalInfo.isEmpty {
                    Text("*\(additionalInfo)*")
                }
            }
        }
        .onAppear() {
            Task(priority: .background) {
                await receiveNotifications()
            }
        }
    }
    
    private func receiveNotifications() async {
        let center = NotificationCenter.default
        let name = Notification.Name("RIAlert")
        
        for await notification in center.notifications(named: name) {
            if let userInfo = notification.userInfo, let moreInfo = userInfo["Language"] as? Language {
                
                await MainActor.run {
                    additionalInfo = "\(moreInfo.name)"
                }
            }
            
            await MainActor.run {
                counter += 1
            }
        }
    }
}

struct SenderView: View {
    var body: some View {
        ZStack {
            Color.orange.opacity(0.2)
            Button("Send Notification") {
                let center = NotificationCenter.default
                let name = Notification.Name("RIAlert")
                
                let language = Language(name: "Swift")
                
                let additionalInfo = ["Language": language]
                
                center.post(name: name, object: nil, userInfo: additionalInfo)
            }
        }
    }
}

struct Language: Codable {
    var name: String
}

enum Orientation {
    case portrait
    case landscape
}

import Observation
final class SystemNotificationExample {
    let center = NotificationCenter.default
    var orientation = Orientation.portrait
    
    init() {
        Task(priority: .background) {
            await orientationChangeNotification()
        }
    }
    
    @MainActor
    func orientationChangeNotification() async {
        let name = UIDevice.orientationDidChangeNotification
        for await notification in center.notifications(named: name) {
            if let device = notification.object as? UIDevice {
                if device.orientation.isPortrait {
                    orientation = .portrait
                } else {
                    orientation = .landscape
                }
            }
        }
    }
}

extension Notification: @unchecked Sendable {}

#Preview {
    ContentView()
}
