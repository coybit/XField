import UIKit

var widespreadFieldIdentifier: String = "*"

protocol GenericField: Equatable {
    var resolved: String { get }
    var allCases: [Self] { get }
    var isWidespread: Bool { get }
    func allCases(exclude excluded: [Self]) -> [Self]
}

extension GenericField  {
    var isWidespread: Bool {
        return self.resolved == widespreadFieldIdentifier
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.resolved.matches(for: "\\w+").first == rhs.resolved.matches(for: "\\w+").first
    }
    
    func allCases(exclude excluded: [Self]) -> [Self] {
        return self.allCases.filter { !excluded.contains($0) }
    }
}

extension String {
    func matches(for regex: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func bracket(ignoreEmptyString: Bool) -> String {
        if self.isEmpty && ignoreEmptyString {
            return self
        }
        return String(format: "{%@}", self)
    }
}

extension Array where Element: GenericField {
    func toString() -> String {
        return self.map { $0.isWidespread ? $0.allCases(exclude: self).toString() : $0.resolved }.joined(separator: ",")
    }
}


// Models

class User {
}

class Car {
}

class Licence {
}

extension User {
    typealias FieldsDescriptor = [User.Field]
    
    enum Field: GenericField {
        case name
        case age
        case car(Car.FieldsDescriptor)
        case all
        
        var resolved: String {
            switch self {
            case .all:
                return widespreadFieldIdentifier
            case .car(let fieldsDescriptor):
                return "car" + fieldsDescriptor.toString().bracket(ignoreEmptyString: true)
            case .age:
                return "age"
            case .name:
                return "name"
            }
        }
        
        var allCases: [Field] {
            return [Field.car([]), Field.age, Field.name]
        }
    }
}

extension Car {
    typealias FieldsDescriptor = [Car.Field]
    
    enum Field: GenericField {
        case model
        case color
        case licence(Licence.FieldsDescriptor)
        case all
        
        var resolved: String {
            switch self {
            case .all:
                return widespreadFieldIdentifier
            case .licence(let fieldsDescriptor):
                return "licence" + fieldsDescriptor.toString().bracket(ignoreEmptyString: true)
            case .color:
                return "color"
            case .model:
                return "model"
            }
        }
        
        var allCases: [Field] {
            return [Field.color, Field.model, Field.licence([])]
        }
    }
}

extension Licence {
    typealias FieldsDescriptor = [Licence.Field]
    
    enum Field: GenericField {
        case number
        case issuedBy
        case all
        
        var resolved: String {
            switch self {
            case .all:
                return widespreadFieldIdentifier
            case .number:
                return "number"
            case .issuedBy:
                return "issuedBy"
            }
        }
        
        var allCases: [Licence.Field] {
            return [Field.issuedBy, Field.number]
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
    let request = UserRequest(xFieldDescriptor: .all, .car([ .color, .all, .licence([ .issuedBy ])]) )
    print(request.xField)
}
