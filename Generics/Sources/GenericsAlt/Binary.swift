//

import Foundation

extension Generic where Repr: GBinary {
    var data: Data {
        Self.representation.data(to)
    }

    init?(data: inout Data) {
        guard let r = Repr.from(&data) else { return nil }
        self = Self.from(r)
    }
}


protocol GBinary: Representation {
    func data(_ value: Structure) -> Data
    static func from(_ data: inout Data) -> Structure?
}

extension Tail: GBinary {
    func data(_ value: ()) -> Data {
        .init()
    }

    static func from(_ data: inout Data) -> Structure? {
        return ()
    }
}

extension Struct: GBinary where Children: GBinary {
    func data(_ value: Children.Structure) -> Data {
        children.data(value)
    }
    static func from(_ data: inout Data) -> Children.Structure? {
        Children.from(&data)
    }
}

extension Prod: GBinary where Head: GBinary, Tail: GBinary {
    func data(_ value: (Head.Structure, Tail.Structure)) -> Data {
        head.data(value.0) + tail.data(value.1)
    }

    static func from(_ data: inout Data) -> (Head.Structure, Tail.Structure)? {
        guard let h = Head.from(&data), let t = Tail.from(&data) else { return nil }
        return (h, t)
    }
}

extension Field: GBinary where Child: Binary {
    func data(_ value: Child) -> Data {
        value.data
    }

    static func from(_ data: inout Data) -> Child? {
        Child(&data)
    }
}

// Primitive types

protocol ToBinary {
    var data: Data { get }
}

protocol FromBinary {
    init?(_ data: inout Data)
}

protocol Binary: ToBinary & FromBinary { }

extension Int: Binary {
    var data: Data {
        withUnsafeBytes(of: self.bigEndian) {
            Data($0)
        }
    }

    init?(_ data: inout Data) {
        let bytes = MemoryLayout<Int>.size
        guard data.count > bytes else { return nil }
        self = data.withUnsafeBytes {
            $0.loadUnaligned(as: Int.self).bigEndian
        }
        data.removeFirst(bytes)
    }
}

extension String: Binary {
    var data: Data {
        utf8.count.data + data(using: .utf8)!
    }

    init?(_ data: inout Data) {
        guard let length = Int(&data) else { return nil }
        let bytes = data.prefix(length)
        guard bytes.count == length else { return nil }
        self = String.init(decoding: bytes, as: UTF8.self)
        data.removeFirst(length)
    }
}

extension Bool: Binary {
    var data: Data {
        Data(self ? [1] : [0])
    }

    init?(_ data: inout Data) {
        guard let f = data.popFirst() else { return nil }
        switch f {
        case 0: self = false
        case 1: self = true
        default: return nil
        }
    }
}
