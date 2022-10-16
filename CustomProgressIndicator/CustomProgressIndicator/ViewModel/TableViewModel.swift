//
//  DataViewModel.swift
//  CustomProgressIndicator
//
//  Created by Shi Pra on 15/10/22.
//

import Foundation
struct TableViewModel {
    var image: String
    var title: String
    
    static func getViewModelData(modelData: [TableModel]) -> [TableViewModel] {
        var data: [TableViewModel] = []
        for i in 0..<modelData.count {
            data.append(TableViewModel(image: modelData[i].imgName, title: modelData[i].label))
        }
        return data
    }
}
