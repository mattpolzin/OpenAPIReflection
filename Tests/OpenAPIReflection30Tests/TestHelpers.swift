//
//  TestHelpers.swift
//
//
//  Created by Mathew Polzin on 6/23/19.
//

import Foundation
import XCTest

let testEncoder = { () -> JSONEncoder in
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    encoder.keyEncodingStrategy = .useDefaultKeys
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    return encoder
}()

//func testStringFromEncoding<T: Encodable>(of entity: T) throws -> String? {
//    return String(data: try testEncoder.encode(entity), encoding: .utf8)
//}
//
//let testDecoder = { () -> JSONDecoder in
//    let decoder = JSONDecoder()
//    decoder.dateDecodingStrategy = .iso8601
//    decoder.keyDecodingStrategy = .useDefaultKeys
//    return decoder
//}()
//
//func assertJSONEquivalent(_ str1: String?, _ str2: String?, file: StaticString = #file, line: UInt = #line) {
//
//    // tests pass with whitespace stripped
//    var str1 = str1
//    var str2 = str2
//
//    str1?.removeAll { $0.isWhitespace }
//    str2?.removeAll { $0.isWhitespace }
//
//    XCTAssertEqual(
//        str1,
//        str2,
//        file: (file),
//        line: line
//    )
//}
