//

import Foundation

extension Generic where Repr: GBinary {
    public var data: Data {
        Self.representation.data(to)
    }

    public init?(_ data: inout Data) {
        guard let r = Repr.from(&data) else { return nil }
        self = Self.from(r)
    }
}


public protocol GBinary: Representation {
    func data(_ value: Structure) -> Data
    static func from(_ data: inout Data) -> Structure?
}

extension Tail: GBinary {
    public func data(_ value: ()) -> Data {
        .init()
    }

    public static func from(_ data: inout Data) -> Structure? {
        return ()
    }
}

extension Struct: GBinary where Children: GBinary {
    public func data(_ value: Children.Structure) -> Data {
        children.data(value)
    }
    public static func from(_ data: inout Data) -> Children.Structure? {
        Children.from(&data)
    }
}

extension Prod: GBinary where Head: GBinary, Tail: GBinary {
    public func data(_ value: (Head.Structure, Tail.Structure)) -> Data {
        head.data(value.0) + tail.data(value.1)
    }

    public static func from(_ data: inout Data) -> (Head.Structure, Tail.Structure)? {
        guard let h = Head.from(&data), let t = Tail.from(&data) else { return nil }
        return (h, t)
    }
}

extension Field: GBinary where Child: ToBinary & FromBinary {
    public func data(_ value: Child) -> Data {
        value.data
    }

    public static func from(_ data: inout Data) -> Child? {
        Child(&data)
    }
}

// Primitive types

public protocol ToBinary {
    var data: Data { get }
}

public protocol FromBinary {
    init?(_ data: inout Data)
}

public protocol Binary: ToBinary & FromBinary { }

extension Date: Binary {
    public var data: Data {
        formatted(.iso8601).data
    }
    public init?(_ data: inout Data) {
        guard let str = String(&data), let d = try? Date.ISO8601FormatStyle().parse(str) else { return nil}
        self = d
    }
}

extension UUID: Binary {
    public var data: Data {
        uuidString.data
    }

    public init?(_ data: inout Data) {
        guard let s = String(&data), let id = UUID(uuidString: s) else { return nil }
        self = id
    }
}

extension Int: Binary {
    public var data: Data {
        withUnsafeBytes(of: self.bigEndian) {
            Data($0)
        }
    }

    public init?(_ data: inout Data) {
        let bytes = MemoryLayout<Int>.size
        guard data.count > bytes else { return nil }
        self = data.withUnsafeBytes {
            $0.loadUnaligned(as: Int.self).bigEndian
        }
        data.removeFirst(bytes)
    }
}

extension String: Binary {
    public var data: Data {
        utf8.count.data + data(using: .utf8)!
    }

    public init?(_ data: inout Data) {
        guard let length = Int(&data) else { return nil }
        let bytes = data.prefix(length)
        guard bytes.count == length else { return nil }
        self = String.init(decoding: bytes, as: UTF8.self)
        data.removeFirst(length)
    }
}

extension Array: ToBinary where Element: ToBinary {
    public var data: Data {
        reduce(into: count.data, { $0 += $1.data })
    }
}

extension Array: FromBinary where Element: FromBinary {
    public init?(_ data: inout Data) {
        guard let length = Int(&data) else { return nil }
        let bytes = data.prefix(length)
        guard bytes.count == length else { return nil }
        self = []
        for _ in 0..<length {
            guard let l = Element(&data) else { return nil }
            append(l)
        }
    }
}


extension Bool: Binary {
    public var data: Data {
        Data(self ? [1] : [0])
    }

    public init?(_ data: inout Data) {
        guard let f = data.popFirst() else { return nil }
        switch f {
        case 0: self = false
        case 1: self = true
        default: return nil
        }
    }
}
