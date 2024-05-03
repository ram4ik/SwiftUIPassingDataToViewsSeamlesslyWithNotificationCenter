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
    
    var body: some View {
        ZStack {
            Color.mint.opacity(0.2)
            Text("Received **\(counter)** notifications.")
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
        
        for await _ in center.notifications(named: name) {
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
                
                center.post(name: name, object: nil)
            }
        }
    }
}

#Preview {
    ContentView()
}
