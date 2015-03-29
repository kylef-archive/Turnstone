//
//  Turnstone.swift
//  Turnstone
//
//  Created by Kyle Fuller on 29/03/2015.
//  Copyright (c) 2015 Cocode. All rights reserved.
//

import Foundation
import Inquiline
import URITemplate


// Simple Nest compatible URI Template Router
public class Turnstone {
  public typealias Parameters = [String:String]
  public typealias Handler = (Environ, Parameters) -> (Response)

  var routes = [(URITemplate, Handler)]()

  /// The handler for when a router isn't found
  public var notFoundHandler:NestApplication = { environ in
    return ("404 NOT FOUND", [("Content-Type", "text/plain; charset=utf8")], "Page Not Found")
  }

  public init() {}

  /** Add a handler for the given URI Template
  :param: uri A URI Template
  :param: handler The handler for the given URI
  */
  public func addRoute(uri:String, handler:Handler) {
    routes.append((URITemplate(template: uri), handler))
  }

  public func addNestRoute(uri:String, handler:NestApplication) {
    routes.append((URITemplate(template: uri), { (environ, parameters) in return handler(environ) }))
  }

  /// A Nest compatible interface
  public func nest(environ:Environ) -> Response {
    if let uri = environ["PATH_INFO"] as? String {
      for (template, handler) in routes {
        if let variables = template.extract(uri) {
          return handler(environ, variables)
        }
      }
    }

    return notFoundHandler(environ)
  }
}
