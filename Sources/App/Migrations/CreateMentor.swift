//
//  CreateMentor.swift
//  
//
//  Created by Khawlah on 16/03/2023.
//

import Fluent

struct CreateMentor: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Mentor.schema)
            .id()
            .field("name", .string, .required)
            .field("email", .string, .required)
            .field("path_id", .uuid, .required, .references(Path.schema, "id"))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Mentor.schema).delete()
    }
}
