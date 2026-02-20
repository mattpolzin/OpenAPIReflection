//
//  AnyJSONCaseIterable.swift
//  OpenAPI
//

import Foundation
import OpenAPIKit30

public protocol AnyRawRepresentable {
    /// The `RawValue` type of this type.
    static var rawValueType: Any.Type { get }
}

extension AnyRawRepresentable where Self: RawRepresentable {
    /// The default `rawValueType` of a `RawRepresentable` is just the
    /// type of `Self.RawValue`.
    public static var rawValueType: Any.Type { return Self.RawValue.self }
}

/// Anything conforming to `AnyJSONCaseIterable` can provide a
/// list of its possible values.
public protocol AnyJSONCaseIterable: AnyRawRepresentable {
    static func allCases(using encoder: JSONEncoder) -> [AnyCodable]
}

extension AnyJSONCaseIterable where Self: RawRepresentable {
    /// The default `rawValueType` of a `RawRepresentable` is just the
    /// type of `Self.RawValue`.
    public static var rawValueType: Any.Type { return Self.RawValue.self }
}

public extension AnyJSONCaseIterable {
    /// Given an array of Codable values, retrieve an array of AnyCodables.
    static func allCases<T: Encodable>(from input: [T], using encoder: JSONEncoder) throws -> [AnyCodable] {
        return try OpenAPIReflection30.allCases(from: input, using: encoder)
    }
}

public extension AnyJSONCaseIterable where Self: CaseIterable, Self: Codable, Self: Sendable {
    static func caseIterableOpenAPISchemaGuess(using encoder: JSONEncoder) throws -> JSONSchema {
        guard let first = allCases.first else {
            throw OpenAPI.EncodableError.exampleNotCodable
        }
        let itemSchema = try OpenAPIReflection30.nestedGenericOpenAPISchemaGuess(for: first, using: encoder)

        return itemSchema.with(allowedValues: allCases.map { AnyCodable($0) })
    }
}

extension CaseIterable where Self: Encodable {
    public static func allCases(using encoder: JSONEncoder) -> [AnyCodable] {
        return (try? OpenAPIReflection30.allCases(from: Array(Self.allCases), using: encoder)) ?? []
    }
}

fileprivate func allCases<T: Encodable>(from input: [T], using encoder: JSONEncoder) throws -> [AnyCodable] {
    if let alreadyGoodToGo = input as? [AnyCodable] {
        return alreadyGoodToGo
    }

    // The following is messy, but it does get us the intended result:
    // Given any array of things that can be encoded, we want
    // to map to an array of AnyCodable so we can store later. We need to
    // muck with JSONSerialization because something like an `enum` may
    // very well be encoded as a string, and therefore representable
    // by AnyCodable, but AnyCodable wants it to actually BE a String
    // upon initialization.

    guard let arrayOfCodables = try JSONSerialization.jsonObject(with: encoder.encode(input), options: []) as? [any Sendable] else {
        throw OpenAPI.EncodableError.allCasesArrayNotCodable
    }
    return arrayOfCodables.map(AnyCodable.init)
}
