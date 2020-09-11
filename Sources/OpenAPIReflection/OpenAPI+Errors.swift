//
//  OpenAPI+Errors.swift
//  
//
//  Created by Mathew Polzin on 4/21/20.
//

import Foundation
import OpenAPIKit

extension OpenAPI {
    public enum TypeError: Swift.Error, CustomDebugStringConvertible {
        case invalidSchema
        case unknownSchemaType(Any.Type)

        public var debugDescription: String {
            switch self {
            case .invalidSchema:
                return "Invalid Schema"
            case .unknownSchemaType(let type):
                return "Could not determine OpenAPI schema type of \(String(describing: type))"
            }
        }
    }

    public enum EncodableError: Swift.Error, Equatable {
        case allCasesArrayNotCodable
        case exampleNotCodable
        case primitiveGuessFailed
        case exampleNotSupported(String)
    }
}
