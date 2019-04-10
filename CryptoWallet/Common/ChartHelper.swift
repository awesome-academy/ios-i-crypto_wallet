//
//  ChartHelper.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/5/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation

enum ChartHelper {
    static func findLabels(data: [(x: Double, y: Double)], axis: Axis, numberPoint: Int) -> [Double] {
        var labels = [Double]()
        if data.count <= numberPoint {
            switch axis {
            case .X:
                data.forEach {
                    labels.append($0.x)
                }
            case .Y:
                data.forEach {
                    labels.append($0.y)
                }
                labels.sort()
            }
            return labels
        }
        switch axis {
        case .X:
            guard let firstElement = data.first, let lastElement = data.last else {
                return []
            }
            var numberPointTemp = numberPoint
            let rangeX = (lastElement.x - firstElement.x) / Double(numberPointTemp - 1)
            labels = [firstElement.x]
            numberPointTemp -= 2
            for i in 0..<numberPointTemp {
                labels.append(round(labels[i] + rangeX))
            }
            labels.append(lastElement.x)
        case .Y:
            guard let maxY = data.max(by: { $0.y < $1.y })?.y,
                let minY = data.min(by: { $0.y < $1.y })?.y else {
                    return []
            }
            var numberPointTemp = numberPoint
            let rangeY = (maxY - minY) / Double(numberPointTemp - 1)
            labels = [minY]
            numberPointTemp -= 2
            for i in 0..<numberPointTemp {
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
