//
//  ResourceController.swift
//  
//
//  Created by Khawlah on 16/03/2023.
//

import Vapor

struct ResourceController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let resources = routes.grouped("resources")
        resources.on(.GET, use: getResources)
        resources.on(.GET, ":pathName", use: getResource)
        
        resources.on(.POST, use: createResource)
        resources.group(":resourceID") { mentor in
            mentor.on(.DELETE, use: deleteResource)
        }
        resources.group(":resourceID") { mentor in
            mentor.on(.PUT, use: updateResource)
        }
    }
    
    func getResources(req: Request) async throws -> [Resource] {
        try await Resource.query(on: req.db).all()
    }
    
    func getResource(req: Request) async throws -> [Resource] {
        let pathName = req.parameters.get("pathName")
        // Fetches all Resources with a path name
        return try await Resource.query(on: req.db).with(\.$path).all().filter({ $0.path.name == pathName })
    }
    
    func createResource(req: Request) async throws -> Resource {
        let resource = try req.content.decode(Resource.self)
        // save on database
        try await resource.save(on: req.db)
        return resource
    }
    
    func deleteResource(req: Request) async throws -> HTTPStatus {
        guard let resource = try await Resource.find(req.parameters.get("resourceID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await resource.delete(on: req.db)
        return .ok
    }
    
    func updateResource(req: Request) async throws -> Resource {
        let input = try req.content.decode(Resource.self)
        guard let resource = try await Resource.find(req.parameters.get("resourceID"), on: req.db) else {
            throw Abort(.notFound)
        }
        resource.title = input.title
        resource.brief = input.brief
        resource.link = input.link
        try await resource.save(on: req.db)
        return resource
    }
}
