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
    var body: some View {
        Text("")
    }
}

struct SenderView: View {
    var body: some View {
        Text("")
    }
}

#Preview {
    ContentView()
}
