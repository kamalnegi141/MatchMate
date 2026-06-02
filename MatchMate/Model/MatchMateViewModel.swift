//
//  MatchMateViewModel.swift
//  MatchMate
//
//  Created by Kamal Negi on 02/06/26.
//

import Foundation
import Combine
import Network
import SwiftData

@MainActor
class MatchMateViewModel: ObservableObject {
    @Published var usersData: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var toast: Toast?

    private var context: ModelContext?
    private let monitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "NetworkMonitor")

    // Call this on app launch — loads cached data first, then refreshes if online
    func loadUsers(context: ModelContext) {
        self.context = context
        let cached = fetchFromSwiftData()
        if !cached.isEmpty {
            usersData = cached
        }
        checkInternetAndFetch()
    }

    // MARK: - SwiftData

    private func fetchFromSwiftData() -> [User] {
        guard let context else { return [] }
        let descriptor = FetchDescriptor<User>(sortBy: [SortDescriptor(\.id)])
        return (try? context.fetch(descriptor)) ?? []
    }

    private func saveToSwiftData(_ users: [User]) {
        guard let context else { return }

        // Preserve existing matchStatus before replacing records
        let existing = fetchFromSwiftData()
        let statusMap = Dictionary(uniqueKeysWithValues: existing.compactMap { user -> (Int, MatchStatus)? in
            guard let id = user.id else { return nil }
            return (id, user.matchStatus)
        })

        existing.forEach { context.delete($0) }

        users.forEach { user in
            if let id = user.id, let savedStatus = statusMap[id] {
                user.matchStatus = savedStatus
            }
            context.insert(user)
        }

        try? context.save()
    }

    // MARK: - Network

    private func checkInternetAndFetch() {
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                if path.status == .satisfied {
                    await self?.fetchUsers()
                } else {
                    self?.errorMessage = "No internet connection"
                }
            }
            self?.monitor.cancel()
        }
        monitor.start(queue: monitorQueue)
    }

    func fetchUsers() async {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }

        isLoading = true
        errorMessage = nil

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode([UserResponse].self, from: data)
            let users = decoded.map { $0.toUser() }
            saveToSwiftData(users)
            usersData = fetchFromSwiftData()
        } catch {
            errorMessage = error.localizedDescription
            showToast(Toast(message: error.localizedDescription, type: .error))
        }

        isLoading = false
    }

    // MARK: - Match Actions

    func onAccept(user: User) {
        guard let index = usersData.firstIndex(of: user) else { return }
        usersData[index].matchStatus = .accepted
        try? context?.save()
        showToast(Toast(message: "\(user.name ?? "User") accepted!", type: .accepted))
    }

    func onDecline(user: User) {
        guard let index = usersData.firstIndex(of: user) else { return }
        usersData[index].matchStatus = .declined
        try? context?.save()
        showToast(Toast(message: "\(user.name ?? "User") declined.", type: .declined))
    }

    private func showToast(_ newToast: Toast) {
        toast = newToast
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            self?.toast = nil
        }
    }
}
