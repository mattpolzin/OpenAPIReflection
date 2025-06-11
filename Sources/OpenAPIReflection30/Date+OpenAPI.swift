//
//  Date+OpenAPI.swift
//  OpenAPI
//
//  Created by Mathew Polzin on 1/24/19.
//

import Foundation
import OpenAPIKit30

extension Date: DateOpenAPISchemaType {
  public static func dateOpenAPISchemaGuess(using encoder: JSONEncoder) -> JSONSchema? {

    switch encoder.dateEncodingStrategy {
    case .deferredToDate, .custom:
      // I don't know if we can say anything about this case without
      // encoding the Date and looking at it, which is what `primitiveGuess()`
      // does.
      return nil

    case .secondsSince1970,
      .millisecondsSince1970:
      return .number(format: .double)

    case .iso8601:
      return .string(format: .dateTime)

  #if !TARGET_OS_LINUX || swift(<5.10)
    case let .formatted(formatter):
      return fromFormatter(formatter)
  #endif

    @unknown default:
      return nil
    }
  }
}


#if !TARGET_OS_LINUX || swift(<5.10)
fileprivate func fromFormatter(_ formatter: DateFormatter) -> JSONSchema {
  let hasTime = formatter.timeStyle != .none
  let format: JSONTypeFormat.StringFormat = hasTime ? .dateTime : .date

  return .string(format: format)
}
#endif

extension Date: OpenAPIEncodedSchemaType {
  public static func openAPISchema(using encoder: JSONEncoder) throws -> JSONSchema {
    guard let dateSchema: JSONSchema = try openAPISchemaGuess(for: Date(), using: encoder) else {
      throw OpenAPI.TypeError.unknownSchemaType(type(of: self))
    }

    return dateSchema
  }
}
