//
//  File.swift
//  
//
//  Created by Mathew Polzin on 3/4/20.
//

import Foundation
import OpenAPIKit
import Sampleable

/// Anything conforming to `OpenAPIEncodedSchemaType` can provide an
/// OpenAPI schema representing itself but it may need an Encoder
/// to do its job.
public protocol OpenAPIEncodedSchemaType {
    static func openAPISchema(using encoder: JSONEncoder) throws -> JSONSchema
}

extension OpenAPIEncodedSchemaType where Self: Sampleable, Self: Encodable {
    public static func openAPINodeWithExample(using encoder: JSONEncoder = JSONEncoder()) throws -> JSONSchema {
        let exampleData = try encoder.encode(Self.successSample ?? Self.sample)
        let example = try JSONDecoder().decode(AnyCodable.self, from: exampleData)
        return try openAPISchema(using: encoder).with(example: example)
    }
}

/// Anything conforming to `RawOpenAPISchemaType` can provide an
/// OpenAPI schema representing itself. This second protocol is
/// necessary so that one type can conditionally provide a
/// schema and then (under different conditions) provide a
/// different schema. The "different" conditions have to do
/// with Raw Representability, hence the name of this protocol.
public protocol RawOpenAPISchemaType {
    static func rawOpenAPISchema() throws -> JSONSchema
}

extension RawOpenAPISchemaType where Self: RawRepresentable, RawValue: OpenAPISchemaType {
    public static func rawOpenAPISchema() throws -> JSONSchema {
        return RawValue.openAPISchema
    }
}

/// Anything conforming to `DateOpenAPISchemaType` is
/// able to attempt to represent itself as a date `JSONSchema`
public protocol DateOpenAPISchemaType {
    static func dateOpenAPISchemaGuess(using encoder: JSONEncoder) -> JSONSchema?
}
