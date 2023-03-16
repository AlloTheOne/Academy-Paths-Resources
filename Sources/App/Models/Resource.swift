//
//  Resource.swift
//  
//
//  Created by Khawlah on 16/03/2023.
//

import Fluent
import Vapor

final class Resource: Model, Content {
    static let schema = "resources"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "brief")
    var brief: String?
    
    @Field(key: "link")
    var link: String
    
    // Reference to the Path this Resource is in.
    @Parent(key: "path_id")
    var path: Path
    
    init() {
    }
    
    init(id: UUID? = nil, title: String, brief: String? = nil, link: String, pathID: UUID) {
        self.id = id
        self.title = title
        self.brief = brief
        self.link = link
        self.$path.id = pathID
    }
}
