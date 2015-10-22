import Spectre
import Nest
import Inquiline
import Turnstone


describe("Turnstone") {
  let turnstone = Turnstone()

  turnstone.notFoundHandler = { request in
    return Response(.NotFound, body: "Custom 404")
  }

  turnstone.addNestRoute("/") { request in
    return Response(.Ok, body: "Root URI")
  }

  turnstone.addRoute("/tasks/{id}") { request, parameters in
    let id = parameters["id"]!
    return Response(.Ok, body: "Task \(id)")
  }

  $0.it("returns 404 response for unhandled URIs") {
    let turnstone = Turnstone()
    let request = Request(method: "GET", path: "/404")
    let response = turnstone.nest(request)
    try equal(response.statusLine, "404 NOT FOUND")
  }

  $0.it("uses the csutom handler for unhandled URIs") {
    let request = Request(method: "GET", path: "/404")
    let response = turnstone.nest(request)
    try equal(response.body, "Custom 404")
  }

  $0.it("matches an added route") {
    let request = Request(method: "GET", path: "/")
    let response = turnstone.nest(request)
    try equal(response.statusLine, "200 OK")
  }

  $0.it("matches an added route with parameters") {
    let request = Request(method: "GET", path: "/tasks/5")
    let response = turnstone.nest(request)
    try equal(response.statusLine, "200 OK")
    try equal(response.body, "Task 5")
  }
}
