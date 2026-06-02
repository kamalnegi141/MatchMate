//
//  UserResponse.swift
//  MatchMate
//

import Foundation

struct UserResponse: Decodable {
    let id: Int?
    let name: String?
    let username: String?
    let email: String?
    let phone: String?
    let website: String?
    let address: AddressResponse?
    let company: CompanyResponse?

    func toUser() -> User {
        User(
            id: id,
            name: name,
            username: username,
            email: email,
            phone: phone,
            website: website,
            address: address.map {
                Address(
                    street: $0.street,
                    suite: $0.suite,
                    city: $0.city,
                    zipcode: $0.zipcode,
                    geo: $0.geo.map { Geo(lat: $0.lat, lng: $0.lng) }
                )
            },
            company: company.map {
                Company(name: $0.name, catchPhrase: $0.catchPhrase, bs: $0.bs)
            }
        )
    }
}

struct AddressResponse: Decodable {
    let street: String?
    let suite: String?
    let city: String?
    let zipcode: String?
    let geo: GeoResponse?
}

struct GeoResponse: Decodable {
    let lat: String?
    let lng: String?
}

struct CompanyResponse: Decodable {
    let name: String?
    let catchPhrase: String?
    let bs: String?
}
