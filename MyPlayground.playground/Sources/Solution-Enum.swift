import UIKit

protocol BasicField {
    var name: String { get }
}

extension Array where Element: BasicField {
    func toString() -> String {
        return self.map { $0.name }.joined(separator: ",")
    }
}

extension String {
    func bracket(ignoreEmptyString: Bool) -> String {
        if self.isEmpty && ignoreEmptyString {
            return self
        }
        return String(format: "{%@}", self)
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
            case .car(let fieldsDescriptor):
                return "car " + fieldsDescriptor.toString().bracket(ignoreEmptyString: true)
            case .age:
                return "age"
            case .name:
                return "name"
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

