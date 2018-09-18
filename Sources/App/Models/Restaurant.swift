//
//  Restaurant.swift
//  App
//
//  Created by Alper Akinci on 14/09/2018.
//

import FluentPostgreSQL
import Vapor

final class Restaurant: PostgreSQLModel {
    var id: Int?
    var name: String

    init(id: Int? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

// The conformance to Content makes it possible so our User can convert into for example JSON using Codable if we would return him in a route. Or so he can convert into TemplateData which is used within a Leaf view. And due to Codable that happens automagically.
extension Restaurant: Content {}

// Conforming to Migration is needed so Fluent can use Codable to create the best possible database table schema and also so we are able to add it to our migration service in our configure.swift
extension Restaurant: Migration {}
