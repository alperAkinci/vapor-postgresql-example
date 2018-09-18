import Vapor
import Leaf
import FluentPostgreSQL
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
    try services.register(FluentPostgreSQLProvider())

    let posgresqlConfig: PostgreSQLDatabaseConfig

    if let url = Environment.get("DATABASE_URL"), let config = PostgreSQLDatabaseConfig(url: url) {
        posgresqlConfig = config
    }else {
        posgresqlConfig = PostgreSQLDatabaseConfig(
            hostname: "127.0.0.1",
            port: 5433,
            username: "alperakinci",
            database: "czechworddb",
            password: nil
        )
    }

    let postgresql = PostgreSQLDatabase(config: posgresqlConfig)
    var databases = DatabasesConfig()
    databases.add(database: postgresql, as: .psql)
    services.register(posgresqlConfig)

    config.prefer(LeafRenderer.self, for: ViewRenderer.self)

    // register a migration service in order to introduce our Model to our database
    var migrations = MigrationConfig()
    migrations.add(model: Word.self, database: .psql)
    services.register(migrations)
}
