//
//  StubThingStorage.swift
//  RememberTests
//
//  Created by Songbai Yan on 2018/4/26.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation

class StubThingStorage: ThingStorage {
    init() {
        super.init(context: CoreStorage.shared.persistentContainer.viewContext)
    }
}
