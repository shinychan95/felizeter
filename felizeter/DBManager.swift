//
//  DBManager.swift
//  felizeter
//
//  Created by USER on 2023/07/07.
//

import Foundation
import SQLite

class DBManager {
    static let shared = DBManager()

    private var db: Connection!

    let keyPresses = Table("KeyPresses")
    let id = Expression<Int64>("id")
    let timeStamp = Expression<Date>("timeStamp")
    let keyPressCount = Expression<Int>("keyPressCount")

    private init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first!

            db = try Connection("\(path)/db.sqlite3")
            try createTableKeyPresses()
        } catch {
            print("Unable to open database. Verify that you created the folder described " +
                  "in the Getting Started section.")
        }
    }

    func createTableKeyPresses() throws {
        try db.run(keyPresses.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(timeStamp)
            t.column(keyPressCount)
        })
    }

    func insertKeyPress(timeStamp: Date, keyPressCount: Int) {
        let insert = keyPresses.insert(self.timeStamp <- timeStamp, self.keyPressCount <- keyPressCount)
        _ = try? db.run(insert)
    }

    func fetchKeyPresses(from startTime: Date?) -> [[String: Any]] {
        guard let startTime = startTime else {
            return []
        }
        
        var rows = [[String: Any]]()
        
        do {
            let formatter = ISO8601DateFormatter()
            let startTimeString = formatter.string(from: startTime)
            
            let stmt = try db.prepare("SELECT * FROM KeyPresses WHERE timestamp >= ?")
            for row in try stmt.run(startTimeString) {
                var dictRow = [String: Any]()
                dictRow["timeStamp"] = row[1]
                dictRow["keyPressCount"] = row[2]
                rows.append(dictRow)
            }
        } catch {
            print("fetchKeyPresses failed: \(error)")
        }
        
        return rows
    }

}
