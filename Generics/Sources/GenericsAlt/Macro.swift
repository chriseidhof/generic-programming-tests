//

import Foundation
import GenericsMacros

@attached(member, names: named(representation), named(from), named(to))
//@attached(extension, conformances: Generic)
public macro GenericAltM() = #externalMacro(module: "GenericsMacros", type: "GenericAltMacro")
