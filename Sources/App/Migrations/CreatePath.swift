//
//  CreatePath.swift
//  
//
//  Created by Alaa Alabdullah on 14/03/2023.
//

import Fluent


struct CreatePath: Migration {
    func prepare(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        return database.schema("paths")
            .id()
            .field("name", .string, .required)
            .field("description", .string, .required)
            .create()
    }
    
    func revert(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        return database.schema("paths").delete()
    }
    
    
}
