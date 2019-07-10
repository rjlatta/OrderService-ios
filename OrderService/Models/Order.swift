//
//  Order.swift
//  OrderService
//
//  Created by Robert Latta on 7/1/19.
//  Copyright © 2019 rl. All rights reserved.
//

import Foundation


class Order : Decodable
{
    var customer : Customer?
    
    var orderDate : String?
    
    var DeliveryDate : String?
    
    var orderList : Array<Product>?
    
    init() {
        customer = Customer()
    }
}
