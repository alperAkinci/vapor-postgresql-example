import Vapor


final class RestaurantController {

    func list(req: Request) -> Future<View> {
        return Restaurant.query(on: req).all().flatMap { (restaurants) in
            let data = ["restaurantList" : restaurants]
            return try req.view().render("restaurantView", data)
        }
    }

    func create(req: Request) throws -> Future<Response> {
        return try req.content.decode(Restaurant.self).flatMap { restaurant in
            return restaurant.save(on: req).map { _ in
                return req.redirect(to: "restaurants")
            }
        }
    }
}
