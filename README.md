# OpenAPI support

See parent library at https://github.com/mattpolzin/OpenAPIKit

# OpenAPIReflection

This library offers extended support for creating OpenAPI types from Swift types. Specifically, this library covers the subset of Swift types that require a `JSONEncoder` to either make an educated guess at the `JSONSchema` for the type or to turn arbitrary types into `AnyCodable` for use as schema examples or allowed values.

## Dates

Dates will create different OpenAPI representations depending on the encoding settings of the `JSONEncoder` passed into the schema construction method.

```swift
// encoder1 has `.iso8601` `dateEncodingStrategy`
let schema = Date().dateOpenAPISchemaGuess(using: encoder1)
// ^ equivalent to:
let sameSchema = JSONSchema.string(
  format: .dateTime
)

// encoder2 has `.secondsSince1970` `dateEncodingStrategy`
let schema2 = Date().dateOpenAPISchemaGuess(using: encoder2)
// ^ equivalent to:
let sameSchema = JSONSchema.number(
  format: .double
)
```

It will even try to take a guess given a custom formatter date decoding
strategy.

## Enums

Swift enums produce schemas with **allowed values** specified as long as they conform to `CaseIterable`, `Encodable`, and `AnyJSONCaseIterable` (the last of which is free given the former two).
```swift
enum CodableEnum: String, CaseIterable, AnyJSONCaseIterable, Codable {
  case one
  case two
}

let schema = CodableEnum.caseIterableOpenAPISchemaGuess(using: JSONEncoder())
// ^ equivalent, although not equatable, to:
let sameSchema = JSONSchema.string(
  allowedValues: "one", "two"
)
```

## Structs

Swift structs produce a best-guess schema as long as they conform to `Sampleable` and `Encodable`
```swift
struct Nested: Encodable, Sampleable {
  let string: String
  let array: [Int]

  // `Sampleable` just enables mirroring, although you could use it to produce
  // OpenAPI examples as well.
  static let sample: Self = .init(
    string: "",
    array: []
  )
}

let schema = Nested.genericOpenAPISchemaGuess(using: JSONEncoder())
// ^ equivalent and indeed equatable to:
let sameSchema = JSONSchema.object(
  properties: [
    "string": .string,
    "array": .array(items: .integer)
  ]
)
```

## Custom OpenAPI type representations

You can take the protocols offered by this library and OpenAPIKit and create arbitrarily complex OpenAPI types from your own Swift types. Right now, the only form of documentation on this subject is the fully realized example over in the [JSONAPI+OpenAPI](https://github.com/mattpolzin/JSONAPI-OpenAPI) library. Just look for conformances to `OpenAPISchemaType` and `OpenAPIEncodedSchemaType`.