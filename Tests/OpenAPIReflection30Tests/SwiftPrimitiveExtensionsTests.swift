//
//  SwiftPrimitiveExtensionsTests.swift
//  
//
//  Created by Mathew Polzin on 3/4/20.
//

import XCTest
import Foundation
import OpenAPIKit30
import OpenAPIReflection30

class SwiftPrimitiveTypesTests: XCTestCase {
    func test_OptionalCaseIterableNodeAllCases() {
        XCTAssertTrue(RawRepStringEnum?.allCases(using: SwiftPrimitiveTypesTests.localTestEncoder).contains("hello"))
        XCTAssertTrue(RawRepStringEnum?.allCases(using: SwiftPrimitiveTypesTests.localTestEncoder).contains("world"))
        XCTAssertEqual(RawRepStringEnum?.allCases(using: SwiftPrimitiveTypesTests.localTestEncoder).count, 2)
    }

    func test_OptionalDateNodeType() {
        XCTAssertEqual(Date?.dateOpenAPISchemaGuess(using: testEncoder), .string(format: .dateTime, required: false))
    }

    func test_RawNodeType() throws {
        XCTAssertEqual(try RawRepStringEnum.rawOpenAPISchema(), .string)
        XCTAssertEqual(try RawRepIntEnum.rawOpenAPISchema(), .integer)
    }

    func test_OptionalRawRepresentable() throws {
        XCTAssertEqual(try RawRepStringEnum?.rawOpenAPISchema(), .string(required: false))

        XCTAssertEqual(try RawRepIntEnum?.rawOpenAPISchema(), .integer(required: false))
    }

    func test_OptionalRawNodeType() throws {
        XCTAssertEqual(try RawRepStringEnum?.rawOpenAPISchema(), .string(required: false))

        XCTAssertEqual(try RawRepIntEnum?.rawOpenAPISchema(), .integer(required: false))
    }

    func test_DoubleWrappedRawNodeType() throws {
        XCTAssertEqual(try RawRepStringEnum??.rawOpenAPISchema(), .string(required: false))

        XCTAssertEqual(try RawRepIntEnum??.rawOpenAPISchema(), .integer(required: false))

        XCTAssertEqual(try RawRepStringEnum??.rawOpenAPISchema(), .string(required: false))

        XCTAssertEqual(try RawRepIntEnum??.rawOpenAPISchema(), .integer(required: false))
    }

    func test_arraySchemaType() throws {
        XCTAssertEqual(try [EncodedSchemaStruct].openAPISchema(using: testEncoder), .array(items: .string))
    }

    func test_dictSchemaType() throws {
        XCTAssertEqual(try [String: EncodedSchemaStruct].openAPISchema(using: testEncoder), .object(additionalProperties: .b(.string)))
    }

    static let localTestEncoder = JSONEncoder()
}

fileprivate enum RawRepStringEnum: String, RawOpenAPISchemaType, CaseIterable, Codable, AnyJSONCaseIterable {
    case hello
    case world
}

fileprivate enum RawRepIntEnum: Int, RawOpenAPISchemaType {
    case one
    case two
}

fileprivate struct EncodedSchemaStruct: OpenAPIEncodedSchemaType {
    static func openAPISchema(using encoder: JSONEncoder) throws -> JSONSchema {
        .string
    }
}
