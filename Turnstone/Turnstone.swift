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


public typealias URI = String
public typealias URIParameters = [String:String]

// Simple Nest compatible request router
public class Turnstone<RequestType, ParametersRequestType, ResponseType> {
  public typealias Handler = ParametersRequestType -> ResponseType
  public typealias NotFoundHandler = RequestType -> ResponseType
  public typealias RequestTransform = (RequestType, URIParameters) -> ParametersRequestType
  public typealias URITransform = RequestType -> URI

  let uriTransform:URITransform
  let requestTransform:RequestTransform
  let notFound:NotFoundHandler

  var routes = [(URITemplate, Handler)]()

  public init(uriTransform:URITransform, requestTransform:RequestTransform, notFound:NotFoundHandler) {
    self.uriTransform = uriTransform
    self.requestTransform = requestTransform
    self.notFound = notFound
  }

  /** Add a handler for the given URI Template
  :param: uri A URI Template
  :param: handler The handler for the given URI
  */
  public func addRoute(uri:URI, handler:Handler) {
    routes.append((URITemplate(template: uri), handler))
  }

  public func route(request:RequestType) -> ResponseType {
    let uri = uriTransform(request)
    for (template, handler) in routes {
      if let parameters = template.extract(uri) {
        let parameterRequest = requestTransform(request, parameters)
        return handler(parameterRequest)
      }
    }

    return notFound(request)
  }
}

/// Returns a Nest compatible turnstone
public func NestTurnstone(notFound:(Environ -> Response)? = nil) -> Turnstone<Environ, Environ, Response> {
  func uriTransform(environ:Environ) -> URI {
    return environ["PATH_INFO"] as? String ?? "/"
  }

  func requestTransform(environ:Environ, parameters:URIParameters) -> (Environ) {
    return (environ)
  }

  func defaultNotFound(environ:Environ) -> Response {
    if let notFound = notFound {
      return notFound(environ)
    }

    return ("404 NOT FOUND", [], "Page Not Found")
  }

  return Turnstone(uriTransform, requestTransform, defaultNotFound)
}

/// Returns a Nest compatible turnstone exposing the URI Parameters
public func NestParameterTurnstone(notFound:(Environ -> Response)? = nil) -> Turnstone<Environ, (Environ, URIParameters), Response> {
  func uriTransform(environ:Environ) -> URI {
    return environ["PATH_INFO"] as? String ?? "/"
  }

  func requestTransform(environ:Environ, parameters:URIParameters) -> (Environ, URIParameters) {
    return (environ, parameters)
  }

  func defaultNotFound(environ:Environ) -> Response {
    if let notFound = notFound {
      return notFound(environ)
    }

    return ("404 NOT FOUND", [], "Page Not Found")
  }

  return Turnstone(uriTransform, requestTransform, defaultNotFound)
}
