//
//  ContentView.swift
//  MatchMate
//
//  Created by Kamal Negi on 02/06/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = MatchMateViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    Text("Profile Matches")
                        .font(.title)
                        .padding(.horizontal, 16)
                    
                    ForEach(viewModel.usersData) { data in
                        MatchMateCardView(profile: data) {
                            viewModel.onAccept(user: data)
                        } onDecline: {
                            viewModel.onDecline(user: data)
                        }
                    }
                }
            }
            
            if let toast = viewModel.toast {
                ToastView(toast: toast)
                    .padding(.bottom, 32)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.spring(), value: viewModel.toast != nil)
            }
        }
        .onAppear {
            viewModel.loadUsers(context: modelContext)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: User.self, inMemory: true)
}
