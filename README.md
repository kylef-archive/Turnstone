# Turnstone

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

var turnstone = Turnstone()

turnstone.addRoute("/") { environ, parameters in
  return ("200 OK", [], "Root URI")
}

turnstone.addRoute("/tasks/{id}") { environ, parameters in
  let id = parameters["id"]!
  return ("200 OK", [], "Task \(id)")
}

serve("localhost", 8080, turnstone.nest)
```

## License

Turnstone is released under the BSD license. See [LICENSE](LICENSE).

