//
//  MentorController.swift
//  
//
//  Created by Khawlah on 16/03/2023.
//

import Vapor
import Fluent

struct MentorController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let mentors = routes.grouped("mentors")
        mentors.get(use: getMentors)
        mentors.get(":id", use: getMentor)
        
        mentors.post(use: createMentor)
        mentors.group(":mentorID") { mentor in
            mentor.delete(use: deleteMentor)
        }
        mentors.group(":mentorID") { mentor in
            mentor.put(use: updateMentor)
        }
        mentors.group(":mentorID") { mentor in
            mentor.patch(use: updateSomeFieldInMentor)
        }
    }
    
    // /mentors?name={mentor name}
    func getMentors(req: Request) async throws -> [Mentor] {
        if let mentorName = req.query[String.self, at: "name"] {
            // Fetches all Resources with a specific path name
            return try await Mentor.query(on: req.db)
                .filter(\.$name == mentorName.capitalized)
                .all()
        } else {
            return try await Mentor.query(on: req.db).all()
        }
    }
    
    // /mentors/{id}
    func getMentor(_ req: Request) async throws ->  Mentor {
        guard let mentor = try await Mentor.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound, reason: "mentor not found")
        }
        return mentor
    }
    
    func createMentor(req: Request) async throws -> Mentor {
        let mentor = try req.content.decode(Mentor.self)
        try await mentor.save(on: req.db)
        return mentor
    }
    
    func deleteMentor(req: Request) async throws -> HTTPStatus {
        guard let mentor = try await Mentor.find(req.parameters.get("mentorID"), on: req.db) else {
            throw Abort(.notFound, reason: "mentor not found")
        }
        try await mentor.delete(on: req.db)
        return .ok
    }
    
    func updateMentor(req: Request) async throws -> Mentor {
        let input = try req.content.decode(Mentor.self)
        guard let mentor = try await Mentor.find(req.parameters.get("mentorID"), on: req.db) else {
            throw Abort(.notFound, reason: "mentor not found")
        }
        mentor.name = input.name
        mentor.email = input.email
        try await mentor.save(on: req.db)
        return mentor
    }
    
    func updateSomeFieldInMentor(req: Request) async throws -> Mentor {
        guard let mentor = try await Mentor.find(req.parameters.get("mentorID"), on: req.db) else {
            throw Abort(.notFound, reason: "mentor not found")
        }
        
        let newMentor = try req.content.decode(MentorRequestObject.self)
        
        if let name = newMentor.name {
            mentor.name = name
        }
        
        if let email = newMentor.email {
            mentor.email = email
        }
        
        try await mentor.save(on: req.db)
        return mentor
    }
}

struct MentorRequestObject: Content {
    var id: UUID?
    var name: String?
    var email: String?
}
