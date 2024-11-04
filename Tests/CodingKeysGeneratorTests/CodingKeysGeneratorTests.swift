import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

@testable import CodingKeysGeneratorMacros
@testable import Shared

let testMacros: [String: Macro.Type] = [
    "CodingKeys": CodingKeysMacro.self,
    "CodingKey": CustomCodingKeyMacro.self,
    "CodingKeyIgnored": CodingKeyIgnoredMacro.self,
]

final class CodingKeysGeneratorTests: XCTestCase {
    func testCodingKeysMacros() {
        let source = """
            @CodingKeys
            struct Entity {
                @CodingKey(custom: "entityID")
                let id: String
                let currentValue: Int
                @CodingKeyIgnored
                let foo: Bool
                let count: Int
                let `protocol`: String
            }
            """
        let expected = """

            struct Entity {
                let id: String
                let currentValue: Int
                let foo: Bool
                let count: Int
                let `protocol`: String

                enum CodingKeys: String, CodingKey {
                    case id = "entityID"
                    case currentValue = "current_value"
                    case count
                    case `protocol`
                }
            }
            """
        assertMacroExpansion(source, expandedSource: expected, macros: testMacros)
    }

    func testKebabCodingKeysMacros() {
        let source = """
            @CodingKeys(style: .kebabCased)
            struct Entity {
                @CodingKey(custom: "entity_id")
                let id: String
                let currentValue: Int
                @CodingKeyIgnored
                let foo: Bool
                let count: Int
                let `protocol`: String
            }
            """
        let expected = """

            struct Entity {
                let id: String
                let currentValue: Int
                let foo: Bool
                let count: Int
                let `protocol`: String

                enum CodingKeys: String, CodingKey {
                    case id = "entity_id"
                    case currentValue = "current-value"
                    case count
                    case `protocol`
                }
            }
            """
        assertMacroExpansion(source, expandedSource: expected, macros: testMacros)
    }
}
