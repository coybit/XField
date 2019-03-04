import UIKit
/*
// Models

protocol PathExpressibleInString {
    associatedtype T
    func stringFor(path: PartialKeyPath<T>) -> String
}

class Customer: PathExpressibleInString {
    var name: String = ""
    var id: String = ""
    
    func stringFor(path: PartialKeyPath<Customer>)  -> String {
        switch path {
        case \Customer.id:
            return "id"
        case \Customer.name:
            return "name"
        default:
            return "ERROR"
        }
    }
}

class Order: PathExpressibleInString {
    var id: String = ""
    var customer: Customer = Customer()
    var products: [String] = []
    
    func stringFor(path: PartialKeyPath<Order>) -> String {
        switch path {
        case \Order.id:
            return "id"
        case \Order.customer:
            return "id"
        case \Order.products:
            return "products"
        default:
            return "ERROR"
        }
    }
}


// API

class OrderRequest {
    var xField: String
    
    init(xField: [PartialKeyPath<Order>]) {
        print(xField, xField.first { $0 == \Order.customer.id })
        self.xField = ""//xField
    }
}

infix operator ~
func ~(lhs: PartialKeyPath<Order>, rhs: [PartialKeyPath<Customer>]) -> PartialKeyPath<Order> {
    return rhs.map { lhs.appending(path: $0)! }.first!
}

// Usage

func demo2() {
    
    //    NSExpression(forKeyPath: \UIView.bounds).keyPath
    
    // { * , id ,  products, customer { * , name } }
    // ToDo: Stuck how pass the second level of keys
    // ToDo: How to pass *
    let request = OrderRequest(xField: [ \Order.id, \Order.products, \Order.customer ~ [ \Customer.id]])
}

*/
