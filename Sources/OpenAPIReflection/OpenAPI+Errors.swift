//
//  File.swift
//  
//
//  Created by Mathew Polzin on 4/21/20.
//

import Foundation
import OpenAPIKit

extension OpenAPI {
    public enum TypeError: Swift.Error, CustomDebugStringConvertible {
        case invalidNode
        case unknownNodeType(Any.Type)

        public var debugDescription: String {
            switch self {
            case .invalidNode:
                return "Invalid Node"
            case .unknownNodeType(let type):
                return "Could not determine OpenAPI node type of \(String(describing: type))"
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
