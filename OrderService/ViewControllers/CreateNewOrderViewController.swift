//
//  ViewController.swift
//  OrderService
//
//  Created by Robert Latta on 7/1/19.
//  Copyright © 2019 rl. All rights reserved.
//

import UIKit
import Foundation

protocol ReturnNewOrderDelegate {
    func NewOrderResponse(order : Order)
}

class CreateNewOrderViewController: UIViewController {

    @IBOutlet var customerNameField : UITextField?
    
    @IBOutlet var customerAddressField : UITextField?
    
    @IBOutlet var orderDateField : UITextField?
    
    @IBOutlet var deliveryDateField : UITextField?
    
    @IBOutlet var productOneField : UITextField?
    
    @IBOutlet var productTwoField : UITextField?
    
    @IBOutlet var productThreeField : UITextField?
    
    @IBOutlet var productFourField : UITextField?
    
    @IBOutlet var returnNewOrder : UIButton?
    
    @IBOutlet var cancelNewOrder : UIButton?
    
    var delegate : ReturnNewOrderDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func commitNewOrder()
    {
        let newOrder : Order = Order()
        if(customerNameField?.text?.count != 0 && customerAddressField?.text?.count != 0 && orderDateField?.text?.count != 0 && deliveryDateField?.text?.count != 0)
        {
            newOrder.customer?.Name = customerNameField?.text
            newOrder.customer?.Address = customerAddressField?.text
            newOrder.orderDate = orderDateField?.text
            newOrder.DeliveryDate = deliveryDateField?.text
            var newOrderList : [Product] = []
            if(productOneField?.text?.count != 0)
            {
                let product : Product = Product()
                product.productType = "Widget"
                product.Quantity = Int((productOneField?.text!)!)
                newOrderList.append(product)
            }
            if(productTwoField?.text?.count != 0)
            {
                let product : Product = Product()
                product.productType = "Thinga ma bob"
                product.Quantity = Int((productTwoField?.text!)!)
                newOrderList.append(product)
            }
            if(productThreeField?.text?.count != 0)
            {
                let product : Product = Product()
                product.productType = "Whatcha ma callit"
                product.Quantity = Int((productThreeField?.text!)!)
                newOrderList.append(product)
            }
            if(productFourField?.text?.count != 0)
            {
                let product : Product = Product()
                product.productType = "Whatcha ma Hoosit"
                product.Quantity = Int((productFourField?.text!)!)
                newOrderList.append(product)
            }
            newOrder.orderList = newOrderList
            
            
            if(delegate != nil)
            {
                delegate?.NewOrderResponse(order: newOrder)
                self.navigationController?.popViewController(animated: true)
                
            }
            else
            {
                //should never be nil
            }
            
        }
        else
        {
            let missingInforAlert : UIAlertController = UIAlertController.init(title: "Attention!", message: "There is missing information that needs to be entered to create a new order", preferredStyle: UIAlertController.Style.alert)
            let cancelAction : UIAlertAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            missingInforAlert.addAction(cancelAction)
            self.navigationController?.present(missingInforAlert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func cancelOrder()
    {
        self.navigationController?.popViewController(animated: true)
    }


}

