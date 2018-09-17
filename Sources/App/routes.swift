import Vapor
import Leaf


/// Register your application's routes here.
public func routes(_ router: Router) throws {

/// The function req.view() creates and returns a ViewRenderer.
/// And since we configured LeafRenderer as our ViewRenderer we can use .leaf files 🍃!


    // VAPOR 3 is all about Futures. And it comes from its nature being Async now.

    // Simple important rule:
    //
    // - We choose map if the body of the call returns a non-future value.
    //
    // - We call flatMap if the body does return a future value.
    //
    // (If that something is a Future you use flatMap
    // and if it is “normal” data thus not a Future you use map.)


    router.get("restaurants") { req -> Future<View> in
        return Restaurant.query(on: req).all().flatMap { (restaurants) in
            let data = ["restaurantList" : restaurants]
            return try req.view().render("restaurantView", data)
        }
    }

    router.post("restaurants") { req -> Future<Response> in
        return try req.content.decode(Restaurant.self).flatMap { restaurant in
            return restaurant.save(on: req).map { _ in
                return req.redirect(to: "restaurants")
            }
        }
    }
}
