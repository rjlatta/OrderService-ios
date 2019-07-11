//
//  OrderListViewController.swift
//  OrderService
//
//  Created by Robert Latta on 7/1/19.
//  Copyright © 2019 rl. All rights reserved.
//

import Foundation
import UIKit

class OrderListViewController : UITableViewController, ReturnNewOrderDelegate
{
    var databaseConnection : OpaquePointer?
    var tableExists : Bool = false
    
    var customerOrderList : [Order] = []
    
    var customerToPass : Int = -1
    
    var destination : String = ""
    
    var manager : DatabaseManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let createNewOrderButton = UIButton(type: .contactAdd)
        
        createNewOrderButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .yellow
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: UIBarButtonItem.Style.plain, target: self, action: #selector(createNewOrder))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Update", style: UIBarButtonItem.Style.plain, target: self, action: #selector(writeToDataBase))
        
        
        openDataBaseConnection()
        createDataBaseTable()
        loadCustomerData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func openDataBaseConnection()
    {
        manager = DatabaseManager()
        databaseConnection = manager!.OpenDatabaseConnection()
    }
    
    func closeDataBaseConnection()
    {
        if(manager != nil)
        {
            manager!.closeDatabaseConnection(connection: databaseConnection!)
        }
    }
    
    func createDataBaseTable()
    {
        tableExists = manager!.CreateTable(connection: databaseConnection!)
    }
    
    func loadCustomerData()
    {
        customerOrderList = manager!.queryDataBase(connection: databaseConnection!)
        manager!.deleteAllData(connection: databaseConnection!)
        tableView.reloadData()
        
    }
    
    @objc func createNewOrder()
    {
        destination = "new"
        self.performSegue(withIdentifier: "shiftToCreateNewOrder", sender: self)
    }
    

    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return customerOrderList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomerOrderTableCell = tableView.dequeueReusableCell(withIdentifier: "CustomerCell", for: indexPath) as! CustomerOrderTableCell
        
        let customer = customerOrderList[indexPath.row]
        
        cell.customerName.text = customer.customer?.Name
        cell.customerAddress.text = customer.customer?.Address
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let customer = customerOrderList[indexPath.row]
        //
        customerToPass = indexPath.row
        destination = "info"
        self.performSegue(withIdentifier: "shiftToViewOrderDetails", sender: self)
        
    }
    
    func NewOrderResponse(order: Order) {
        customerOrderList.append(order)
        
    }
    
    @objc func writeToDataBase()
    {
        var count = 1
        for writeOrder in customerOrderList
        {
            var productString = "{\"customerOrder\" : ["
            for writeProduct in writeOrder.orderList
            {
                productString += String(format: "{\"productType\" : \"%@\", \"quantity\" : %d},", writeProduct.productType!, writeProduct.Quantity!)
            }
            productString.removeLast()
            productString.append("]}")
            manager!.insertRow(connection: databaseConnection!, id: Int32(count), name: writeOrder.customer!.Name!, address: writeOrder.customer!.Address!, orderDate: writeOrder.orderDate!, deliveryDate: writeOrder.DeliveryDate!, orderList: productString)

            
            count += 1
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(destination == "info")
        {
            let infoController = segue.destination as! ViewOrderDetailViewController
            infoController.displayOrder = customerOrderList[customerToPass]
        }
        if(destination == "new")
        {
            let newCustomerController = segue.destination as! CreateNewOrderViewController
            newCustomerController.delegate = self
        }
    }
    
    deinit {
        manager!.closeDatabaseConnection(connection: databaseConnection!)
        databaseConnection = nil
        manager = nil
        customerOrderList.removeAll()
        
    }
}
