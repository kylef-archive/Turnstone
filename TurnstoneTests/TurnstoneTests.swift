//
//  TurnstoneTests.swift
//  TurnstoneTests
//
//  Created by Kyle Fuller on 29/03/2015.
//  Copyright (c) 2015 Cocode. All rights reserved.
//

import Foundation
import XCTest
import Inquiline
import Turnstone

class NestTurnstoneTests: XCTestCase {
  var turnstone:Turnstone<Environ, Environ, Response>!

  override func setUp() {
    turnstone = NestTurnstone()
  }

  func testReturns404ForUnhandledURIs() {
    let response = turnstone.route([:])
    XCTAssertEqual(response.0, "404 NOT FOUND")
  }

  func testCustomHandlerForUnhandledURIs() {
    turnstone = NestTurnstone({ environ in
      return ("200 CUSTOM NOT FOUND", [], "Custom Not Found")
    })

    let response = turnstone.route([:])
    XCTAssertEqual(response.2!, "Custom Not Found")
  }

  func testRegisteredURI() {
    turnstone.addRoute("/") { environ in
      return ("200 OK", [], "Root URI")
    }

    let response = turnstone.route(["PATH_INFO": "/"])
    XCTAssertEqual(response.0, "200 OK")
  }
}

class NestParameterTurnstoneTests: XCTestCase {
  var turnstone:Turnstone<Environ, (Environ, URIParameters), Response>!

  override func setUp() {
    turnstone = NestParameterTurnstone()
  }

  func testReturns404ForUnhandledURIs() {
    let response = turnstone.route([:])
    XCTAssertEqual(response.0, "404 NOT FOUND")
  }

  func testCustomHandlerForUnhandledURIs() {
    turnstone = NestParameterTurnstone({ environ in
      return ("200 CUSTOM NOT FOUND", [], "Custom Not Found")
    })

    let response = turnstone.route([:])
    XCTAssertEqual(response.2!, "Custom Not Found")
  }

  func testRegisteredURI() {
    turnstone.addRoute("/") { (environ, parameters) in
      return ("200 OK", [], "Root URI")
    }

    let response = turnstone.route(["PATH_INFO": "/"])
    XCTAssertEqual(response.0, "200 OK")
  }

  func testRegisteredURIVariable() {
    turnstone.addRoute("/tasks/{id}") { (environ, parameters) in
      let id = parameters["id"]!
      return ("200 OK", [], "Tasks \(id)")
    }

    let response = turnstone.route(["PATH_INFO": "/tasks/5"])
    XCTAssertEqual(response.2!, "Tasks 5")
  }
}
