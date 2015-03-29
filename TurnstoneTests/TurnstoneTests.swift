//
//  TurnstoneTests.swift
//  TurnstoneTests
//
//  Created by Kyle Fuller on 29/03/2015.
//  Copyright (c) 2015 Cocode. All rights reserved.
//

import Foundation
import XCTest
import Turnstone

class TurnstoneTests: XCTestCase {
  var turnstone = Turnstone()

  func testReturns404ForUnhandledURIs() {
    let response = turnstone.nest([:])
    XCTAssertEqual(response.0, "404 NOT FOUND")
  }

  func testCustomHandlerForUnhandledURIs() {
    turnstone.notFoundHandler = { environ in
      return ("200 CUSTOM NOT FOUND", [], "Custom Not Found")
    }

    let response = turnstone.nest([:])
    XCTAssertEqual(response.2!, "Custom Not Found")
  }

  func testRegisteredURI() {
    turnstone.addRoute("/") { environ in
      return ("200 OK", [], "Root URI")
    }

    let response = turnstone.nest(["PATH_INFO": "/"])
    XCTAssertEqual(response.0, "200 OK")
  }

  func testRegisteredURIVariables() {
    turnstone.addRoute("/tasks/{id}") { environ, parameters in
      let id = parameters["id"]!
      return ("200 OK", [], "Task \(id)")
    }

    let response = turnstone.nest(["PATH_INFO": "/tasks/5"])
    XCTAssertEqual(response.0, "200 OK")
    XCTAssertEqual(response.2!, "Task 5")
  }
}
