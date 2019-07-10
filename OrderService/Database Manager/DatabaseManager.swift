//
//  DatabaseManager.swift
//  OrderService
//
//  Created by Robert Latta on 7/1/19.
//  Copyright © 2019 rl. All rights reserved.
//

import Foundation
import SQLite3


class DatabaseManager
{
    let createTableString = """
    CREATE TABLE Orders(
    Id INT PRIMARY KEY NOT NULL,
    Name CHAR(255),
    Address CHAR(255),
    OrderDate CHAR(255),
    DeliveryDate CHAR(255),
    OrderList CHAR(255));
    """
    
    func OpenDatabaseConnection() -> OpaquePointer?
    {
        let databaseURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("orderdatabase.sqlite")
        
        var db : OpaquePointer? = nil
        
        if sqlite3_open(databaseURL.path, &db) == SQLITE_OK
        {
            print("Successfully opened connection to database at \(databaseURL.path)")
            return db
        }
        else
        {
            return nil
        }
    }
    
    func CreateTable(connection : OpaquePointer) -> Bool
    {
        var createTableStatement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(connection, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                //Table created
                sqlite3_finalize(createTableStatement)
                return true
            }
            else
            {
                //Table failed to be created
                sqlite3_finalize(createTableStatement)
                return false
            }
        }
        else
        {
            //Table exists already
            sqlite3_finalize(createTableStatement)
            return true
        }
    }
    
    func insertRow(connection : OpaquePointer, id : Int32, name : String, address : String, orderDate : String, deliveryDate : String, orderList : String)
    {
        //let insertStatementString = "INSERT INTO Orders (Id, Name, Address, OrderDate, DeliveryDate, OrderList) VALUES (?, ?, ?, ?, ?, ?);"
        let insertStatementString = "INSERT INTO Orders (Id, Name, Address, OrderDate, DeliveryDate, OrderList) VALUES (\(id), \(name), \(address), \(orderDate), \(deliveryDate), \(orderList));"
        var insertStatement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(connection, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK
        {
            //sqlite3_bind_int(insertStatement, 1, id)
            //sqlite3_bind_text(insertStatement, 2, name, -1, nil)
            //sqlite3_bind_text(insertStatement, 3, address, -1, nil)
            //sqlite3_bind_text(insertStatement, 4, orderDate, -1, nil)
            //sqlite3_bind_text(insertStatement, 5, deliveryDate, -1, nil)
            //sqlite3_bind_text(insertStatement, 6, orderList, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE
            {
                sqlite3_finalize(insertStatement)
                //Row inserted
            }
            else
            {
                sqlite3_finalize(insertStatement)
                //Failed to insert row
            }
        }
        else
        {
            
        }
    }
    
    func deleteRow(connection : OpaquePointer, row : Int) -> Bool
    {
        var deleteStatementString = "DELETE FROM Orders WHERE Id = \(row)"
        var deleteStatement : OpaquePointer? = nil
        if sqlite3_prepare_v2(connection, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK
        {
            if(sqlite3_step(deleteStatement) == SQLITE_DONE)
            {
                sqlite3_finalize(deleteStatement)
                return true
            }
            else
            {
                sqlite3_finalize(deleteStatement)
                return false
            }
        }
        else{
            sqlite3_finalize(deleteStatement)
            return false
        }
    }
    
    func queryDataBase(connection : OpaquePointer) -> Array<Order>
    {
        var returnList : Array<Order> = []
        let queryStatmentString = "SELECT * FROM Orders"
        var queryStatment : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(connection, queryStatmentString, -1, &queryStatment, nil) == SQLITE_OK
        {
            while(sqlite3_step(queryStatment) == SQLITE_ROW)
            {
                let order = Order()
                if let extractValueName = sqlite3_column_text(queryStatment, 1)
                {
                    order.customer!.Name = String(cString: extractValueName)
                }
                if let extractValueAddress = sqlite3_column_text(queryStatment, 2)
                {
                    order.customer!.Address = String(cString: extractValueAddress)
                }
                if let extractValueOrderDate = sqlite3_column_text(queryStatment, 3)
                {
                    order.orderDate = String(cString: extractValueOrderDate)
                }
                if let extractValueDeliveryDate = sqlite3_column_text(queryStatment, 4)
                {
                    order.DeliveryDate = String(cString: extractValueDeliveryDate)
                }
                if let extractValueCustomerOrder = sqlite3_column_text(queryStatment, 5)
                {
                    
                    let removeEscapingCharacters = String(cString: extractValueCustomerOrder).replacingOccurrences(of: "\\", with: "", options: NSString.CompareOptions.literal, range: nil)
                    print(removeEscapingCharacters)
                    if let data = removeEscapingCharacters.data(using: .utf8)
                    {
                        do{
                            let dict =  try JSONSerialization.jsonObject(with: data, options: []) as? [String:[String:String]]
                            if let extractList = dict!["customerOrder"] //as? [ Product ]
                            {
                                //order.orderList = extractList
                                print("test")
                            }
                        }
                        catch let error{
                            print(error)
                        }
                    }
                }
                 
                
                returnList.append(order)
            }
        }
        
        return returnList
    }
    func closeDatabaseConnection(connection : OpaquePointer)
    {
        sqlite3_close(connection)
    }
}
