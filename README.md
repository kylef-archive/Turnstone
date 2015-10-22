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
import Inquiline

let turnstone = Turnstone()

turnstone.addRoute("/") { request in
  return Response(.Ok, body: "Root URI")
}

turnstone.addRoute("/tasks/{id}") { request, parameters in
  let id = parameters["id"]!
  return Response(.Ok, body: "Task \(id)")
}

serve("localhost", 8080, turnstone.nest)
```

## License

Turnstone is released under the BSD license. See [LICENSE](LICENSE).
