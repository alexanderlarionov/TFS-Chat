//
//  DateUtil.swift
//  TFS Chat
//
//  Created by dmitry on 19.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import Foundation

struct DateUtil {
   
    static func formatForView(date: Date) -> String {
        let formattedDate: String
        /// Создание инстанс DateFormatter занимает довольно много времени
        /// Рекоендую создать два инстанса DateFormatter с разными dateFormat
        /// Сохранить их в переменные (или сделать ленивыми)
        /// И потом использовать их в зависимости от условия
        
        
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(date) {
            formatter.dateFormat = "HH:mm"
            formattedDate = formatter.string(from: date)
        } else {
            formatter.dateFormat = "dd MMM"
            formattedDate = formatter.string(from: date)
        }
        return formattedDate
    }
}
