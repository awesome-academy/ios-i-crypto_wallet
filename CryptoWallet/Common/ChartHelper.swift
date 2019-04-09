//
//  ChartHelper.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/5/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation

enum ChartHelper {
    static func findLabels(data: [(x: Double, y: Double)], axis: Axis, numberLabel: Int) -> [Double] {
        var labels = [Double]()
        switch axis {
        case .X:
            guard let firstElement = data.first, let lastElement = data.last else {
                return []
            }
            var numberLabelTemp = numberLabel
            let rangeX = (lastElement.x - firstElement.x) / Double(numberLabelTemp - 1)
            labels = [firstElement.x]
            numberLabelTemp -= 2
            for i in 0..<numberLabelTemp {
                labels.append(round(labels[i] + rangeX))
            }
            labels.append(lastElement.x)
        case .Y:
            guard let maxY = data.max(by: { $0.y < $1.y })?.y,
                let minY = data.min(by: { $0.y < $1.y })?.y else {
                    return []
            }
            var numberLabelTemp = numberLabel
            let rangeY = (maxY - minY) / Double(numberLabelTemp - 1)
            labels = [minY]
            numberLabelTemp -= 2
            for i in 0..<numberLabelTemp {
                labels.append(round(labels[i] + rangeY))
            }
            labels.append(maxY)
        }
        return labels
    }
}

enum Axis {
    case X
    case Y
}
