import Vapor
import Leaf
import FluentSQLite
/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register leaf
    let leafProvider = LeafProvider()
    try services.register(leafProvider)

    // Register FluentSQLite provider
    try services.register(FluentSQLiteProvider())

    //initiate a database service
    var databases = DatabasesConfig()
    //add a SQLiteDatabase to it
    try databases.add(database: SQLiteDatabase(storage: .memory), as: .sqlite)
    //and register that database service
    services.register(databases)

    config.prefer(LeafRenderer.self, for: ViewRenderer.self)

    // register a migration service in order to introduce our Model to our database
    var migrations = MigrationConfig()
    migrations.add(model: Restaurant.self, database: .sqlite)
    services.register(migrations)
}
