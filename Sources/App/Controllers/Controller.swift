import Vapor


final class Controller {

    func list(req: Request) -> Future<View> {
        return Word.query(on: req).all().flatMap { words in
            let data = ["wordList" : words]
            return try req.view().render("view", data)
        }
    }

    func create(req: Request) throws -> Future<Response> {
        return try req.content.decode(Word.self).flatMap { word in
            return word.save(on: req).map { _ in
                return req.redirect(to: "test")
            }
        }
    }
}
