//
//  Sampleable+OpenAPI.swift
//  OpenAPIReflection
//
//  Created by Mathew Polzin on 1/24/19.
//

import Foundation
import Sampleable
import OpenAPIKit

extension Sampleable where Self: Encodable {
    public static func genericOpenAPISchemaGuess(using encoder: JSONEncoder) throws -> JSONSchema {
        return try OpenAPIReflection.genericOpenAPISchemaGuess(for: Self.sample, using: encoder)
    }
}

public func genericOpenAPISchemaGuess<T>(for value: T, using encoder: JSONEncoder) throws -> JSONSchema {
    // short circuit for dates
    if let date = value as? Date,
        let node = try type(of: date)
            .dateOpenAPISchemaGuess(using: encoder)
            ?? reencodedSchemaGuess(for: date, using: encoder) {

        return node
    }

    let mirror = Mirror(reflecting: value)
    let properties: [(String, JSONSchema)] = try mirror.children.compactMap { child in

        // see if we can enumerate the possible values
        let maybeAllCases: [AnyCodable]? = {
            switch type(of: child.value) {
            case let valType as AnyJSONCaseIterable.Type:
                return valType.allCases(using: encoder)
            default:
                return nil
            }
        }()

        // try to snag an OpenAPI Schema
        let openAPINode: JSONSchema = try openAPISchemaGuess(for: child.value, using: encoder)
            ?? nestedGenericOpenAPISchemaGuess(for: child.value, using: encoder)

        // put it all together
        let newNode: JSONSchema
        if let allCases = maybeAllCases {
            newNode = openAPINode.with(allowedValues: allCases)
        } else {
            newNode = openAPINode
        }

        return zip(child.label, newNode) { ($0, $1) }
    }

    if properties.count != mirror.children.count {
        throw OpenAPI.TypeError.unknownSchemaType(type(of: value))
    }

    // There should not be any duplication of keys since these are
    // property names, but rather than risk runtime exception, we just
    // fail to the newer value arbitrarily
    let propertiesDict = Dictionary(properties) { _, value2 in value2 }

    return .object(required: true, properties: propertiesDict)
}

/// Same as genericOpenAPISchemaGuess() except it checks if there's an easy
/// way out via an explicit conformance to one of the OpenAPISchema protocols.
internal func nestedGenericOpenAPISchemaGuess<T>(for value: T, using encoder: JSONEncoder) throws -> JSONSchema {
    if let schema = try openAPISchemaGuess(for: value, using: encoder) {
        return schema
    }

    return try genericOpenAPISchemaGuess(for: value, using: encoder)
}

internal func reencodedSchemaGuess<T: Encodable>(for value: T, using encoder: JSONEncoder) throws -> JSONSchema? {
    let data = try encoder.encode(PrimitiveWrapper(primitive: value))
    let wrappedValue = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])

    guard let wrapperDict = wrappedValue as? [String: Any],
        wrapperDict.contains(where: { $0.key == "primitive" }) else {
            throw OpenAPI.EncodableError.primitiveGuessFailed
    }

    let value = (wrappedValue as! [String: Any])["primitive"]!

    return try openAPISchemaGuess(for: value, using: encoder)
}

internal func openAPISchemaGuess(for type: Any.Type, using encoder: JSONEncoder) throws -> JSONSchema? {
    let nodeGuess: JSONSchema? = try {
        switch type {
        case let valType as OpenAPISchemaType.Type:
            return valType.openAPISchema

        case let valType as RawOpenAPISchemaType.Type:
            return try valType.rawOpenAPISchema()

        case let valType as DateOpenAPISchemaType.Type:
            return valType.dateOpenAPISchemaGuess(using: encoder)

        case let valType as OpenAPIEncodedSchemaType.Type:
            return try valType.openAPISchema(using: encoder)

        case let valType as AnyRawRepresentable.Type:
            if valType.rawValueType != valType {
                let guess = try openAPISchemaGuess(for: valType.rawValueType, using:
                    encoder)
                return valType is _Optional.Type
                    ? guess?.optionalSchemaObject()
                    : guess
            } else {
                return nil
            }

        default:
            return nil
        }
    }()

    return nodeGuess
}

internal func openAPISchemaGuess(for value: Any, using encoder: JSONEncoder) throws -> JSONSchema? {
    // ideally the type specifies how to get an OpenAPI node from itself.
    let nodeGuess: JSONSchema? = try openAPISchemaGuess(for: type(of: value), using: encoder)

    if nodeGuess != nil {
        return nodeGuess
    }

    // Second we can try for a few primitive types.
    // This is only necessary because when decoding
    // types like `NSTaggedPointerString` will be recognized
    // by the following switch statement even though
    // `NSTaggedPointerString` does not conform to
    // `OpenAPISchemaType` like `String` does.
    let primitiveGuess: JSONSchema? = try {
        switch value {
        case is String:
            return .string

        case is Int:
            return .integer

        case is Double:
            return .number(
                format: .double
            )

        case is Bool:
            return .boolean

        case is Data:
            return .string(
                format: .binary
            )

        case is DateOpenAPISchemaType:
            // we don't know what Date will end up looking like without
            // trying it out. Most likely a `.string` or `.number(format: .double)`
            return try OpenAPIReflection.reencodedSchemaGuess(for: Date(), using: encoder)

        default:
            return nil
        }
    }()

    return primitiveGuess
}

// The following wrapper is only needed because JSONEncoder cannot yet encode
// JSON fragments. It is a very unfortunate limitation that requires silly
// workarounds in edge cases like this.
private struct PrimitiveWrapper<Wrapped: Encodable>: Encodable {
    let primitive: Wrapped
}

private protocol _Optional {}
extension Optional: _Optional {}
