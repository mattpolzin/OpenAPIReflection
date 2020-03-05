//
//  SwiftPrimitiveExtensionsTests.swift
//  
//
//  Created by Mathew Polzin on 3/4/20.
//

import XCTest
import Foundation
import OpenAPIReflection
import OpenAPIKit

class SwiftPrimitiveTypesTests: XCTestCase {
    func test_OptionalCaseIterableNodeAllCases() {
        XCTAssertTrue(RawRepStringEnum?.allCases(using: SwiftPrimitiveTypesTests.localTestEncoder).contains("hello"))
        XCTAssertTrue(RawRepStringEnum?.allCases(using: SwiftPrimitiveTypesTests.localTestEncoder).contains("world"))
        XCTAssertEqual(RawRepStringEnum?.allCases(using: SwiftPrimitiveTypesTests.localTestEncoder).count, 2)
    }

    func test_OptionalDateNodeType() {
        XCTAssertEqual(Date?.dateOpenAPISchemaGuess(using: testEncoder), .string(format: .dateTime, required: false))
    }

    func test_RawNodeType() {
        XCTAssertEqual(try! RawRepStringEnum.rawOpenAPISchema(), .string)
        XCTAssertEqual(try! RawRepIntEnum.rawOpenAPISchema(), .integer)
    }

    func test_OptionalRawRepresentable() {
        XCTAssertEqual(try! RawRepStringEnum?.rawOpenAPISchema(), .string(required: false))

        XCTAssertEqual(try! RawRepIntEnum?.rawOpenAPISchema(), .integer(required: false))
    }

    func test_OptionalRawNodeType() {
        XCTAssertEqual(try! RawRepStringEnum?.rawOpenAPISchema(), .string(required: false))

        XCTAssertEqual(try! RawRepIntEnum?.rawOpenAPISchema(), .integer(required: false))
    }

    func test_DoubleWrappedRawNodeType() {
        XCTAssertEqual(try! RawRepStringEnum??.rawOpenAPISchema(), .string(required: false))

        XCTAssertEqual(try! RawRepIntEnum??.rawOpenAPISchema(), .integer(required: false))

        XCTAssertEqual(try! RawRepStringEnum??.rawOpenAPISchema(), .string(required: false))

        XCTAssertEqual(try! RawRepIntEnum??.rawOpenAPISchema(), .integer(required: false))
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
