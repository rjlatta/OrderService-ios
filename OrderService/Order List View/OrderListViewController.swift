//
//  OrderListViewController.swift
//  OrderService
//
//  Created by Robert Latta on 7/1/19.
//  Copyright © 2019 rl. All rights reserved.
//

import Foundation
import UIKit

class OrderListViewController : UITableViewController
{
    var databaseConnection : OpaquePointer?
    var tableExists : Bool = false
    
    var customerOrderList : [Order] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let createNewOrderButton = UIButton(type: .contactAdd)
        
        createNewOrderButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        
        let manager : DatabaseManager = DatabaseManager()
        databaseConnection = manager.OpenDatabaseConnection()
        tableExists = manager.CreateTable(connection: databaseConnection!)
        
        if(tableExists)
        {
            //let test = "\'{\"customerOrder\" : [{\"productType\" : \"Widget\", \"quantity\" : 5}, {\"productType\" : \"Whatcha ma callit\", \"quantity\" : 5}]}]}\'".replacingOccurrences(of: "\\", with: "")
            
            manager.insertRow(connection: databaseConnection!, id: 1, name: "\'Tim Jim\'", address: "\'1234 RoadSt. Somewhere, There 12345\'", orderDate: "\'01/01/1111\'", deliveryDate: "\'03/03/1111\'", orderList: "\'{\"customerOrder\" : [{\"productType\" : \"Widget\", \"quantity\" : 5}, {\"productType\" : \"Whatcha ma callit\", \"quantity\" : 5}]}\'")
        }
        
        //let test = manager.queryDataBase(connection: databaseConnection!)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomerOrderTableCell = tableView.dequeueReusableCell(withIdentifier: "CustomerCell", for: indexPath) as! CustomerOrderTableCell
        
        let customer = customerOrderList[indexPath.row]
        
        cell.customerName.text = customer.customer?.Name
        cell.customerAddress.text = customer.customer?.Address
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customer = customerOrderList[indexPath.row]
        
    }
}
