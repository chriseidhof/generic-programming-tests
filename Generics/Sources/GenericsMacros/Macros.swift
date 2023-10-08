import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

extension DeclSyntax {
    var storedProperty: (TokenSyntax, TypeSyntax)? {
        guard let v = self.as(VariableDeclSyntax.self) else { return nil }
        let binding = v.bindings.first!
        guard let id = binding.pattern.as(IdentifierPatternSyntax.self) else { return nil }

        guard let type = binding.typeAnnotation?.type else { return nil }

        guard binding.initializer?.value == nil else {
            fatalError() // todo
        }
        return (id.identifier, type)
    }
}

struct GenericMacroError: Error {
    var message: String
}

struct GenericMacro: MemberMacro {
    static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            throw GenericMacroError(message: "TODO")
        }
        let storedProperties: [(TokenSyntax, TypeSyntax)] = declaration.memberBlock.members.compactMap {
                $0.decl.storedProperty
            }
        let decl: DeclSyntax = storedProperties.reversed().reduce("Tail") { result, t in
            "Prod<Field<\(t.1)>, \(result)>"
        }
        let childTo: DeclSyntax = storedProperties.reversed().reduce("Tail()") { result, t in
            let fieldName = t.0.text
            return "Prod(head: Field(name: \(literal: fieldName), value: \(t.0)), tail: \(result))"
        }
        let name = structDecl.name.with(\.trailingTrivia, []).text
        let inits: [DeclSyntax] = storedProperties.enumerated().map { (n, prop) in
            let t = prop.0
            var result: DeclSyntax = "\(t): rep.children"
            for _ in 0..<n {
                result = "\(result).tail"
            }
            result = "\(result).head.value"
            return result
        }
        let i: DeclSyntax = inits.dropFirst().reduce(inits.first!, { result, d in
            "\(result), \(d)"
        })
        return [
            "typealias Rep = Struct<\(decl)>",
            """
            var rep: Rep {
                Struct(name: \(literal: name), children: \(childTo))
            }
            static func from(_ rep: Rep) -> Self {
                Self(\(raw: i))
            }
            """
        ]
    }
}

struct GenericAltMacro: MemberMacro {
    static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            throw GenericMacroError(message: "TODO")
        }
        let storedProperties: [(TokenSyntax, TypeSyntax)] = declaration.memberBlock.members.compactMap {
                $0.decl.storedProperty
            }
        let decl: DeclSyntax = storedProperties.reversed().reduce("Tail") { result, t in
            "Prod<Field<\(t.1)>, \(result)>"
        }
        let childTo: DeclSyntax = storedProperties.reversed().reduce("Tail()") { result, t in
            let fieldName = t.0.text
            return "Prod(head: Field<\(t.1)>(name: \(literal: fieldName)), tail: \(result))"
        }
        let name = structDecl.name.with(\.trailingTrivia, []).text
        let inits: [DeclSyntax] = storedProperties.enumerated().map { (n, prop) in
            let t = prop.0
            var result: DeclSyntax = "\(t): rep"
            for _ in 0..<n {
                result = "\(result).1"
            }
            result = "\(result).0"
            return result
        }
        let i: DeclSyntax = inits.dropFirst().reduce(inits.first!, { result, d in
            "\(result), \(d)"
        })
        let toText: DeclSyntax = storedProperties.reversed().reduce("()", { result, prop in
            "(\(prop.0), \(result))"
        })
        return [
//            "typealias Rep = Struct<\(decl)>",
            """
            static let representation =
                Struct(name: \(literal: name), children: \(childTo))

            static func from(_ rep: Repr.Structure) -> Self {
                Self(\(raw: i))
            }

            var to: Repr.Structure {
                \(toText)
            }
            """
        ]
    }
}
