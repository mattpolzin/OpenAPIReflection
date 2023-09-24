//
//  SwiftPrimitiveExtensions.swift
//  
//
//  Created by Mathew Polzin on 3/4/20.
//

import Foundation
import OpenAPIKit

extension Optional: AnyRawRepresentable where Wrapped: AnyRawRepresentable {
    public static var rawValueType: Any.Type { Wrapped.rawValueType }
}

extension Optional: AnyJSONCaseIterable where Wrapped: AnyJSONCaseIterable {
    public static func allCases(using encoder: JSONEncoder) -> [AnyCodable] {
        return Wrapped.allCases(using: encoder)
    }
}

extension Optional: RawOpenAPISchemaType where Wrapped: RawOpenAPISchemaType {
    static public func rawOpenAPISchema() throws -> JSONSchema {
        return try Wrapped.rawOpenAPISchema().optionalSchemaObject()
    }
}

extension Optional: DateOpenAPISchemaType where Wrapped: DateOpenAPISchemaType {
    static public func dateOpenAPISchemaGuess(using encoder: JSONEncoder) -> JSONSchema? {
        return Wrapped.dateOpenAPISchemaGuess(using: encoder)?.optionalSchemaObject()
    }
}

extension Array: OpenAPIEncodedSchemaType where Element: OpenAPIEncodedSchemaType {
    public static func openAPISchema(using encoder: JSONEncoder) throws -> JSONSchema {
        return .array(
            .init(
                format: .generic,
                required: true
            ),
            .init(
                items: try Element.openAPISchema(using: encoder)
            )
        )
    }
}

extension Dictionary: RawOpenAPISchemaType where Key: RawRepresentable, Key.RawValue == String, Value: OpenAPISchemaType {
    static public func rawOpenAPISchema() throws -> JSONSchema {
        return .object(
            .init(
                format: .generic,
                required: true
            ),
            .init(
                properties: [:],
                additionalProperties: .init(Value.openAPISchema)
            )
        )
    }
}

extension Dictionary: OpenAPIEncodedSchemaType where Key == String, Value: OpenAPIEncodedSchemaType {
    public static func openAPISchema(using encoder: JSONEncoder) throws -> JSONSchema {
        return .object(
            .init(
                format: .generic,
                required: true
            ),
            .init(
                properties: [:],
                additionalProperties: .init(try Value.openAPISchema(using: encoder))
            )
        )
    }
}
