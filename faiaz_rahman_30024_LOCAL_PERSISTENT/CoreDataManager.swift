//
//  CoreDataManager.swift
//  faiaz_rahman_30024_LOCAL_PERSISTENT
//
//  Created by bjit on 10/1/23.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
    // table <-> entity <-> class
    
    static let shared = CoreDataManager()
   // var count = 0
    
    private init() {}
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func getAllRecords() -> [ExpenseModel]? {
        var result = [ExpenseModel]()
        do {
            //expenseModels = try  context.fetch(ExpenseModel.fetchRequest())
            let fetchRequest = NSFetchRequest<ExpenseModel>(entityName: "ExpenseModel")
            result = try context.fetch(fetchRequest)
            return result
        } catch {
            print(error)
            return nil
        }
    }
    
    func addCategory(named name: String,
                     completion: (ExpenseCategory) -> ()) {
        
        let category = ExpenseCategory(context: context)
        category.name = name
        do {
            try context.save()
            completion(category)
        } catch {
            print(error)
        }
    }
    
    func addRecord(count: inout Int,
                   categoryName: String,
                   completion: (ExpenseModel) -> ()) {
        
        let item = ExpenseModel(context: context)
        count += 1
        item.name = "test \(count)"
        item.date = Date()
        item.amount = Double(Int.random(in: 1...200))
        item.test = "test"
        
        let fetchRequest = NSFetchRequest<ExpenseCategory>(entityName: "ExpenseCategory")
        let predicate = NSPredicate(format: "name == %@", categoryName)
        fetchRequest.predicate = predicate
        
        do {
            let category = try context.fetch(fetchRequest).first
            category?.addToExpenses(item)
            //item.category = category
            try context.save()
            completion(item)
        } catch {
            print(error)
        }
    }
    
    func getRecord(named name: String) -> [ExpenseModel]? {
        
        let fetchRequest = NSFetchRequest<ExpenseModel>(entityName: "ExpenseModel")
        //let predicate = NSPredicate(format: "name LIKE[cd] %@ AND amount BETWEEN {%i, %i}", name, 20, 180)
        //let format = "NOT name CONTAINS %@ AND NOT amount BETWEEN {%i, %i}"
        let format = "NOT name CONTAINS %@ AND amount > 20 AND amount < 100"
        let predicate = NSPredicate(format: format, name, 20, 180)
        fetchRequest.predicate = predicate
        
        var result: [ExpenseModel]?
        do {
            result = try context.fetch(fetchRequest)
            return result
        } catch {
            print(error)
            return nil
        }
    }
    
    func deleteRecord(at index: Int,
                      from expenseList: [ExpenseModel],
                      completion: (Int) -> ()) {
        
        let item = expenseList[index]
        context.delete(item)
        
        do {
            try context.save()
            completion(index)
        } catch {
            print(error)
        }
    }
    
    func updateRecord(at index: Int,
                      from expenseList: [ExpenseModel],
                      completion: (Int, ExpenseModel) -> ()) {
        
        let item = expenseList[index]
        item.name = "UPdated"
        
        do {
            try context.save()
            completion(index, item)
        } catch {
            print(error)
        }
    }
    
}
