import XCTest
import Nest
import Inquiline
import Turnstone

class TurnstoneTests: XCTestCase {
  var turnstone = Turnstone()

  func testReturns404ForUnhandledURIs() {
    let request = Request(method: "GET", path: "/")
    let response = turnstone.nest(request)
    XCTAssertEqual(response.statusLine, "404 NOT FOUND")
  }

  func testCustomHandlerForUnhandledURIs() {
    turnstone.notFoundHandler = { request in
      return Response(.NotFound, body: "Custom 404")
    }

    let request = Request(method: "GET", path: "/")
    let response = turnstone.nest(request)
    XCTAssertEqual(response.body, "Custom 404")
  }

  func testRegisteredURI() {
    turnstone.addNestRoute("/") { request in
      return Response(.Ok, body: "Root URI")
    }

    let request = Request(method: "GET", path: "/")
    let response = turnstone.nest(request)
    XCTAssertEqual(response.statusLine, "200 OK")
  }

  func testRegisteredURIVariables() {
    turnstone.addRoute("/tasks/{id}") { environ, parameters in
      let id = parameters["id"]!
      return Response(.Ok, body: "Task \(id)")
    }

    let request = Request(method: "GET", path: "/tasks/5")
    let response = turnstone.nest(request)
    XCTAssertEqual(response.statusLine, "200 OK")
    XCTAssertEqual(response.body, "Task 5")
  }
}
