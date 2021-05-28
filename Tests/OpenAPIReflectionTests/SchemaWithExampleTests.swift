//
//  SchemaWithExampleTests.swift
//  
//
//  Created by Mathew Polzin on 9/10/20.
//

import XCTest
import Foundation
import OpenAPIKit30
import OpenAPIReflection
import Sampleable

final class SchemaWithExampleTests: XCTestCase {
    func test_structWithExample() throws {

        let schemaGuess = try Test.openAPISchemaWithExample(using: testEncoder)
        let expectedSchema = try JSONSchema.object(
            properties: [
                "string": .string,
                "int": .integer,
                "bool": .boolean,
                "double": .number(format: .double)
            ]
        ).with(example:
            [
              "bool" : true,
              "double" : 2.34,
              "int" : 10,
              "string" : "hello"
            ]
        )

        XCTAssertNotNil(schemaGuess.jsonType)

        XCTAssertEqual(
            schemaGuess.jsonType,
            expectedSchema.jsonType
        )

        XCTAssertNotNil(schemaGuess.objectContext)

        XCTAssertEqual(
            schemaGuess.objectContext,
            expectedSchema.objectContext
        )

        XCTAssertNotNil(schemaGuess.example)

        // equality checks on AnyCodable are finicky but
        // they compare equally when encoded to data.
        XCTAssertEqual(
            try testEncoder.encode(schemaGuess.example),
            try testEncoder.encode(expectedSchema.example)
        )
    }
}

extension SchemaWithExampleTests {
    struct Test: Codable, Sampleable, OpenAPIEncodedSchemaType {
        let string: String
        let int: Int
        let bool: Bool
        let double: Double

        public static let sample: SchemaWithExampleTests.Test = .init(
            string: "hello",
            int: 10,
            bool: true,
            double: 2.34
        )

        static func openAPISchema(using encoder: JSONEncoder) throws -> JSONSchema {
            return .object(
                properties: [
                    "string": .string,
                    "int": .integer,
                    "bool": .boolean,
                    "double": .number(format: .double)
                ]
            )
        }
    }
}
