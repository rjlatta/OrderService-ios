//
//  ViewOrderDetailsViewController.swift
//  OrderService
//
//  Created by Robert Latta on 7/8/19.
//  Copyright © 2019 rl. All rights reserved.
//

import Foundation
import UIKit

class ViewOrderDetailViewController : UIViewController
{
    @IBOutlet var nameLabel : UILabel?
    
    @IBOutlet var addressLabel : UILabel?
    
    @IBOutlet var oderDateLabel : UILabel?
    
    @IBOutlet var deliveryDateLabel : UILabel?
    
    @IBOutlet var orderList : UILabel?
    
    var displayOrder : Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (displayOrder != nil)
        {
            nameLabel?.text = displayOrder!.customer!.Name
            addressLabel?.text = displayOrder!.customer!.Address
            oderDateLabel?.text = displayOrder!.orderDate
            deliveryDateLabel?.text = displayOrder!.DeliveryDate
            var orderString : String = ""
            for order in displayOrder!.orderList!
            {
                let stringToAppend = order.productType! + "    " + String(order.Quantity!) + "\n"
                orderString.append(stringToAppend)
            }
            
            orderList?.text = orderString
        }
    }
}
