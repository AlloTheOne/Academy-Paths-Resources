//
//  Mentor.swift
//  
//
//  Created by Khawlah on 16/03/2023.
//

import Fluent
import Vapor

final class Mentor: Model, Content {
    static let schema = "mentors"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "email")
    var email: String
    
    // Reference to the Path this Mentor is in.
    @Parent(key: "path_id")
    var path: Path
    
    init() {
    }
    
    init(id: UUID? = nil, name: String, email: String, pathID: UUID) {
        self.id = id
        self.name = name
        self.email = email
        self.$path.id = pathID
    }
}
