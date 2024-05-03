//
//  ContentView.swift
//  SwiftUIPassingDataToViewsSeamlesslyWithNotificationCenter
//
//  Created by Ramill Ibragimov on 5/3/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                ReceiverView()
                SenderView()
            }
            .navigationTitle("Passing data to Views")
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

#Preview {
    ContentView()
}
