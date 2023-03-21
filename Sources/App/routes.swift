import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "For the complete documentation check out this link: https://app.swaggerhub.com/templates-docs/KHAWLAHALRASHED/Academy/1.0.0#/"
    }
    
    try app.register(collection: PathController())
    try app.register(collection: ResourceController())
    try app.register(collection: MentorController())
}
