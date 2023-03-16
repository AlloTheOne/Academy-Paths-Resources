//
//  Path.swift
//  
//
//  Created by Alaa Alabdullah on 14/03/2023.
//

import Fluent
import Vapor

final class Path: Model, Content {
    static let schema = "paths"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "description")
    var description: String
    
    init() { }
    
    init(id: UUID? = nil, name: String, description: String) {
        self.id = id
        self.name = name
        self.description = description
    }
}
