//
//  DBHelper.swift
//  youtubeplayer
//
//  Created by KHUSHBOO on 07/06/20.
//  Copyright © 2020 Khushboo. All rights reserved.
//

import Foundation
import SQLite3

class DBHelper
{
    
    init()
    {
        db = openDatabase()
        createTable()
    }

    let dbPath: String = "videosDB.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func createTable()
    {
        let createTableString = "CREATE TABLE IF NOT EXISTS Videos(id INTEGER PRIMARY KEY,title TEXT,author TEXT, videoid TEXT, imageurl TEXT, duration TEXT , videourl TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("restaurant table created.")
            } else {
                print("restaurant table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
   func insert(_ item: Itemlist_Model) -> Bool
      {
          let success : Bool?
        _ = read
          /*for r in rest
          {
              if r.id == expenses.id
              {
                  success = false
                  return success
              }
          }*/
          let insertStatementString = "INSERT INTO Videos (title, author, videoid, imageurl, duration ,videourl ) VALUES (?, ?, ?, ?, ?, ?);"
          var insertStatement: OpaquePointer? = nil
          if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK
          {
              
            sqlite3_bind_text(insertStatement, 1, (item.title! as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (item.author! as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (item.videoid! as NSString).utf8String, -1, nil)
              
            sqlite3_bind_text(insertStatement, 4, (item.img_url! as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (item.videoduration! as NSString).utf8String, -1, nil)
             sqlite3_bind_text(insertStatement, 6, (item.videourl! as NSString).utf8String, -1, nil)
             
              
              if sqlite3_step(insertStatement) == SQLITE_DONE
              {
                  print("Successfully inserted row.")
                  success = true
              } else
              {
                  print("Could not insert row.")
                  success = false
                  
              }
          } else {
              print("INSERT statement could not be prepared.")
              success = false
          }
          sqlite3_finalize(insertStatement)
          return success!
      }
      
      func read() -> [Itemlist_Model]
      {
          
          
        let queryStatementString = "SELECT * FROM Videos;"
         
          var queryStatement: OpaquePointer? = nil
        var res : [Itemlist_Model] = [Itemlist_Model]()
          if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
              while sqlite3_step(queryStatement) == SQLITE_ROW {
                  
                  let expense: [String: Any] = ["id": sqlite3_column_int(queryStatement, 0),
                  "title": String(describing: String(cString: sqlite3_column_text(queryStatement, 1))),
                  "author": String(describing: String(cString: sqlite3_column_text(queryStatement, 2))),
                  "videoid": String(describing: String(cString: sqlite3_column_text(queryStatement, 3))),
                  "imageurl": String(describing: String(cString: sqlite3_column_text(queryStatement, 4))),
                  "duration": String(describing: String(cString: sqlite3_column_text(queryStatement, 5))),
                  "videourl": String(describing: String(cString: sqlite3_column_text(queryStatement, 6))),
                  ]
                  
                let itemmodel : Itemlist_Model = Itemlist_Model()
                itemmodel.title = expense["title"] as? String
                itemmodel.author = expense["author"] as? String
                itemmodel.videoid = expense["videoid"] as? String
                itemmodel.img_url = expense["imageurl"] as? String
                itemmodel.videoduration = expense["duration"] as? String
                 itemmodel.videourl = expense["videourl"] as? String
              
                  print("Query Result:")
                res.append(itemmodel)
                  print(expense)
              }
          }
          else
          {
              print("SELECT statement could not be prepared")
          }
          sqlite3_finalize(queryStatement)
          return res
      }
    
    func checkforvideo(videoid : String) -> Bool
    {
        var success :Bool = false
        let queryStatementString = String(format: "SELECT videoid FROM Videos WHERE videoid = '%@'",videoid)
         
          var queryStatement: OpaquePointer? = nil
        
          if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK
          {
              while sqlite3_step(queryStatement) == SQLITE_ROW
              {
                let _: [String: Any] = ["videoid": String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))]
                success = true
                  
            }
        }
        else
        {
            print("SELECT statement could not be prepared")
            success = false
            
        }
        sqlite3_finalize(queryStatement)
        return success
    }
}
