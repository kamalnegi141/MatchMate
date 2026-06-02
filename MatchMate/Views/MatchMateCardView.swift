//
//  MatchMateCardView.swift
//  MatchMate
//
//  Created by Kamal Negi on 02/06/26.
//

import SwiftUI
import SDWebImageSwiftUI

struct MatchMateCardView: View {
    var profile: User
    var onAccept: () -> Void = {}
    var onDecline: () -> Void = {}
    @State private var isAnimating = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let url = URL(string: profile.imageString) {
                WebImage(
                    url: url,
                    scale: 1,
                    options: [],
                    context: nil,
                    isAnimating: $isAnimating
                ) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }

            Text(profile.name ?? "")
                .font(.headline)

            Label(profile.email ?? "", systemImage: "envelope.fill")
                .font(.caption)
                .foregroundColor(.secondary)

            Label(profile.address?.city ?? "", systemImage: "mappin.and.ellipse")
                .font(.caption)
                .foregroundColor(.secondary)

            switch profile.matchStatus {
            case .none:
                HStack(spacing: 16) {
                    Button(action: onDecline) {
                        Label("Decline", systemImage: "xmark")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .foregroundColor(.red)
                            .cornerRadius(12)
                    }

                    Button(action: onAccept) {
                        Label("Accept", systemImage: "checkmark")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .foregroundColor(.green)
                            .cornerRadius(12)
                    }
                }

            case .accepted:
                Label("Accepted", systemImage: "checkmark.seal.fill")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .foregroundColor(.green)
                    .cornerRadius(12)

            case .declined:
                Label("Declined", systemImage: "xmark.seal.fill")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .foregroundColor(.red)
                    .cornerRadius(12)
            }

        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
}

#Preview {
    let user = User(
        id: 1,
        name: "Leanne Graham",
        username: "Bret",
        email: "Sincere@april.biz",
        phone: "1-770-736-8031 x56442",
        website: "hildegard.org",
        address: Address(
            street: "Kulas Light",
            suite: "Apt. 556",
            city: "Gwenborough",
            zipcode: "92998-3874",
            geo: Geo(lat: "-37.3159", lng: "81.1496")
        ),
        company: Company(
            name: "Romaguera-Crona",
            catchPhrase: "Multi-layered client-server neural-net",
            bs: "harness real-time e-markets"
        )
    )
    MatchMateCardView(profile: user)
}
