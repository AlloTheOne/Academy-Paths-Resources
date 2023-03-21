//
//  PathController.swift
//  
//
//  Created by Alaa Alabdullah on 16/03/2023.
//


import Vapor

struct PathController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let path = routes.grouped("paths")
        path.get(use: index)
        path.get(":id", use: getHandler)
    }
    
    // get req - paths route
    func index(req: Request) throws -> EventLoopFuture<[Path]> {
        return Path.query(on: req.db).with(\.$resources).with(\.$mentors).all()
    }

    
    // get req by id - paths route
    func getHandler(_ req: Request) async throws ->  Path {
        
        guard let path = try await Path.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound, reason: "path not found")
        }
        return path
    } 
}
