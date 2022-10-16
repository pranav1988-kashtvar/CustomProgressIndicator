//
//  TableModel.swift
//  CustomProgressIndicator
//
//  Created by Shi Pra on 15/10/22.
//

import Foundation

struct TableModel {
    var imgName: String
    var label: String
    
    static func getTableData() -> [TableModel]{
        var data: [TableModel] = []
        for i in 0..<5 {
            data.append(TableModel(imgName: "summericons_100px_0\(i)", label: "Cell Title For \(i)"))
        }
        return data
    }
}
