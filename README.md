# Turnstone

[![Build Status](http://img.shields.io/travis/kylef/Turnstone/master.svg?style=flat)](https://travis-ci.org/kylef/Turnstone)

Lightweight request routing for [Nest](https://github.com/nestproject/Nest).
Turnstone allows you to register a URI Template against a handler to provide
request routing.

## Installation

```ruby
pod 'Turnstone'
```

## Usage

```swift
import Turnstone

var turnstone = NestParameterTurnstone()

turnstone.addRoute("/") { environ, parameters in
  return ("200 OK", [], "Root URI")
}

turnstone.addRoute("/tasks/{id}") { environ, parameters in
  let id = parameters["id"]!
  return ("200 OK", [], "Task \(id)")
}

serve("localhost", 8080, turnstone.route)
```

## License

Turnstone is released under the BSD license. See [LICENSE](LICENSE).

