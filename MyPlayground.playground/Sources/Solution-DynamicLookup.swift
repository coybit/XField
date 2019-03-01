import UIKit

@dynamicMemberLookup
class Field: CustomStringConvertible {
    
    // MARK: Static properties
    
    static let widespreadLabel = "all"
    static let widespreadResolved = "*"
    
    // MARK: Properties
    
    var label: String
    var childeren: [Field]
    
    private var resolvedLabel: String {
        if label == Field.widespreadLabel {
            return Field.widespreadResolved
        } else {
            return label
        }
    }
    
    var description: String {
        return resolvedLabel + childeren.commaSeparated.bracket(ignoreEmptyString: true)
    }
    
    
    // MARK: Lifecycle
    
    init() {
        self.label = ""
        self.childeren = []
    }
    
    init(label: String) {
        self.label = label
        self.childeren = []
    }
    
    init(parent: Field, childeren: [Field]) {
        self.label = parent.label
        self.childeren = childeren
    }
    
    subscript(dynamicMember member: String) -> Field {
        return Field(label: member)
    }
}

extension Array where Element: Field {
    var commaSeparated: String {
        return self.map { $0.description }.joined(separator: ", ")
    }
}

//extension String {
//    func bracket(ignoreEmptyString: Bool) -> String {
//        if self.isEmpty && ignoreEmptyString {
//            return self
//        }
//        return String(format: " { %@ } ", self)
//    }
//}

infix operator ~
func ~(lhs: Field, rhs: [Field]) -> Field {
    return Field(parent: lhs, childeren: rhs)
}

typealias XFieldDescriptionBlock = (Field)->[Field]

class XField {
    private var fields: [Field]
    
    var xField: String {
        return fields.commaSeparated.bracket(ignoreEmptyString: true)
    }
    
    init(descriptor: XFieldDescriptionBlock, counterpart: Counterpart.Type) {
        self.fields = descriptor(Field())
        
        print("isValid: \(validate(fields: self.fields, counterpart: counterpart))")
    }
    
    private func validate(fields: [Field], counterpart: Counterpart.Type) -> Bool {
        guard !fields.isEmpty else {
            return true
        }
        
        for field in fields {
            
            if field.label == Field.widespreadLabel {
                continue
            }
            
            guard let subCounterpart = counterpart.fields[field.label] else {
                return false
            }
            
            if subCounterpart == PrimitiveCounterpart.self {
                continue
            }
            
            if  !validate(fields: field.childeren, counterpart: subCounterpart) {
                return false
            }
        }
        
        return true
    }
    
}

protocol Counterpart {
    static var fields: [String : Counterpart.Type] { get }
}

class PrimitiveCounterpart: Counterpart {
    static var fields: [String : Counterpart.Type] = [:]
}


// Models

class House {
}

class Address {
}

extension Address: Counterpart {
    static var fields: [String : Counterpart.Type] = [
        "city": PrimitiveCounterpart.self,
        "zipcode": PrimitiveCounterpart.self
    ]
}

extension House: Counterpart {
    static var fields: [String : Counterpart.Type] = [
        "price": PrimitiveCounterpart.self,
        "address": Address.self
    ]
}


// API

class BuyHouseRequest {
    init(xFieldDescriptor: XFieldDescriptionBlock) {
        let xField = XField(descriptor: xFieldDescriptor, counterpart: House.self)
        print(xField.xField)
    }
}

// Usage

public func demoDLM() {
    // XField = "*, price, address { zipcode, city }}"
    BuyHouseRequest(xFieldDescriptor: {[
        $0.all,
        $0.price,
        $0.address ~ [
            $0.zipcode,
            $0.city
        ]
        ]})
    
    BuyHouseRequest(xFieldDescriptor: {[ $0.all, $0.address ~ [ $0.zipcode9 ]]})
}
