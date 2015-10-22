import Nest
import Inquiline
import URITemplate


// Simple Nest compatible URI Template Router
public class Turnstone {
  public typealias Parameters = [String: String]
  public typealias Application = (RequestType, Parameters) -> ResponseType

  typealias Route = (URITemplate, Application)

  var routes = [Route]()

  /// The handler for when a router isn't found
  public var notFoundHandler: Nest.Application = { request in
    return Response(.NotFound, contentType: "text/plain; charset=utf8", body: "Page Not Found")
  }

  public init() {}

  /** Add a handler for the given URI Template
  - parameter uri: A URI Template
  - parameter handler: The handler for the given URI
  */
  public func addRoute(uri: String, application: Application) {
    routes.append((URITemplate(template: uri), application))
  }

  public func addNestRoute(uri: String, application: Nest.Application) {
    addRoute(uri) { request, parameters in
      application(request)
    }
  }

  /// A Nest compatible interface
  public func nest(request: RequestType) -> ResponseType {
    for (template, handler) in routes {
      if let variables = template.extract(request.path) {
        return handler(request, variables)
      }
    }

    return notFoundHandler(request)
  }
}
