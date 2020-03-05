# OpenAPIReflection

A subset of supported Swift types require a `JSONEncoder` either to make an educated guess at the `JSONSchema` for the type or in order to turn arbitrary types into `AnyCodable` for use as schema examples or allowed values.

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
