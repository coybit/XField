import UIKit

protocol BasicField {
    var name: String { get }
    var subFields: String { get }
}

extension Array where Element: BasicField {
    func toString() -> String {
        let expanded = self.map { field in
            return field.name + field.subFields.bracket(ignoreEmptyString: true)
            }.joined(separator: ",")
        return expanded
    }
}

extension String {
    func bracket(ignoreEmptyString: Bool) -> String {
        if self.isEmpty && ignoreEmptyString {
            return self
        }
        return String(format: " { %@ } ", self)
    }
}


// Models

class User {
}

class Car {
}

extension User {
    typealias FieldsDescriptor = [User.Field]
    
    enum Field: BasicField {
        case all
        case name
        case age
        case car(Car.FieldsDescriptor)
        
        var name: String {
            switch self {
            case .all:
                return "*"
            case .car:
                return "car"
            case .age:
                return "age"
            case .name:
                return "name"
            }
        }
        
        var subFields: String {
            switch self {
            case .car(let fieldsDescriptor):
                return fieldsDescriptor.toString()
            default:
                return ""
            }
        }
    }
}

extension Car {
    typealias FieldsDescriptor = [Car.Field]
    
    enum Field: BasicField {
        case model
        case color
        case all
        
        var name: String {
            switch self {
            case .all:
                return "*"
            case .color:
                return "color"
            case .model:
                return "model"
            }
        }
        
        var subFields: String {
            return ""
        }
    }
}


// API

class UserRequest {
    var xField: String
    
    init(xFieldDescriptor: User.Field...) {
        self.xField = xFieldDescriptor.toString()
    }
}

// Usage

public func demoEnum() {
    // XField = "* , name , car { * , color }"
    let request = UserRequest(xFieldDescriptor: .all, .name, .car ([ .all, .color ]) )
    print(request.xField)
}

