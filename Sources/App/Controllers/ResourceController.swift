//
//  ResourceController.swift
//  
//
//  Created by Khawlah on 16/03/2023.
//

import Vapor
import Fluent

struct ResourceController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let resources = routes.grouped("resources")
        resources.on(.GET, use: getAllResources)
        resources.on(.GET, ":pathName", use: getResources)
        
        resources.on(.POST, use: createResource)
        resources.on(.DELETE, ":resourceID", use: deleteResource)
        
        resources.on(.PUT, ":resourceID", use: updateResource)
        resources.on(.PATCH, ":resourceID", use: updateSomeFieldInResource)
    }
    
    func getAllResources(req: Request) async throws -> [Resource] {
        try await Resource.query(on: req.db).all()
    }
    
    func getResources(req: Request) async throws -> [Resource] {
        let pathName = req.parameters.get("pathName")!
        // Fetches all Resources with a specific path name
        return try await Resource.query(on: req.db)
            .join(Path.self, on: \Resource.$path.$id == \Path.$id)
            .filter(Path.self, \.$name == pathName.capitalized)
            .all()
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
        if let resource = try await Resource.find(req.parameters.get("resourceID"), on: req.db) {
            resource.title = input.title
            resource.brief = input.brief
            resource.link = input.link
            try await resource.update(on: req.db)
            return resource
        } else {
            return try await createResource(req: req)
        }
    }
    
    func updateSomeFieldInResource(req: Request) async throws -> Resource {
        guard let resource = try await Resource.find(req.parameters.get("resourceID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let newResource = try req.content.decode(ResourceRequestObject.self)
        
        if let title = newResource.title {
            resource.title = title
        }
        
        if let brief = newResource.brief {
            resource.brief = brief
        }
        
        if let link = newResource.link {
            resource.link = link
        }
        
        try await resource.save(on: req.db)
        return resource
    }
}

struct ResourceRequestObject: Content {
    var id: UUID?
    var title: String?
    var brief: String?
    var link: String?
}
