// User.swift

import Foundation
import SwiftData

enum MatchStatus: String, Codable {
    case accepted
    case declined
    case none
}

@Model
final class User {
    var id: Int?
    var name: String?
    var username: String?
    var email: String?
    var phone: String?
    var website: String?
    var address: Address?
    var company: Company?
    var matchStatus: MatchStatus = MatchStatus.none

    var imageString: String {
        "https://i.pravatar.cc/150?img=\(id ?? 1)"
    }

    init(id: Int? = nil, name: String? = nil, username: String? = nil, email: String? = nil, phone: String? = nil, website: String? = nil, address: Address? = nil, company: Company? = nil, matchStatus: MatchStatus = .none) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.phone = phone
        self.website = website
        self.address = address
        self.company = company
        self.matchStatus = matchStatus
    }
}

struct Address: Codable {
    var street: String?
    var suite: String?
    var city: String?
    var zipcode: String?
    var geo: Geo?
}

struct Geo: Codable {
    var lat: String?
    var lng: String?
}

struct Company: Codable {
    var name: String?
    var catchPhrase: String?
    var bs: String?
}

