//
//  CreateResource.swift
//  
//
//  Created by Khawlah on 16/03/2023.
//

import Fluent

struct CreateResource: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Resource.schema)
            .id()
            .field("title", .string, .required)
            .field("brief", .string)
            .field("link", .string, .required)
            .field("path_id", .uuid, .required, .references(Path.schema, "id"))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Resource.schema).delete()
    }
}
