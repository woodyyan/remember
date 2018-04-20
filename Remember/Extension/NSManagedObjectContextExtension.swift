//
//  NSManagedObjectContextExtension.swift
//  Remember
//
//  Created by Songbai Yan on 2018/4/19.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    public func saveIfNeeded() {
        if self.hasChanges {
            do {
                try self.save()
            } catch {
                print(error.localizedDescription)
                let nserror = error as NSError
                print(nserror.userInfo)
            }
        }
    }
}
