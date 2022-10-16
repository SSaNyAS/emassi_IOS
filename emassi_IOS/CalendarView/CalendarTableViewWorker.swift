//
//  CalendarTableViewWorker.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 16.10.2022.
//

import UIKit

class CalendarTableViewWorker: NSObject, UITableViewDataSource{
    var works: [AllWork] = []{
        didSet{
            works = works.sorted(by: {
                let dateComponents1 = Calendar.current.dateComponents(neeedsDateComponents, from: $0.date.start)
                let dateComponents2 = Calendar.current.dateComponents(neeedsDateComponents, from: $1.date.start)
                return dateComponents1 == dateComponents2
            })
        }
    }
    private let neeedsDateComponents: Set<Calendar.Component> = [.day,.weekday,.month,.year]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if works.count == 1 {
            return 1
        }
        var uniqueItemsCount = 0
        for itemId in 0..<works.count{
            let workCurrent = works[itemId]
            if itemId + 1 < works.count{
                let workNext = works[itemId + 1]
                let dateComponents1 = Calendar.current.dateComponents(neeedsDateComponents, from: workCurrent.date.start)
                let dateComponents2 = Calendar.current.dateComponents(neeedsDateComponents, from: workNext.date.start)
                if dateComponents1 != dateComponents2{
                    uniqueItemsCount += 1
                }
            }
        }
        
        return uniqueItemsCount
    }
    
    func getOrders(dateComponents: DateComponents) -> [AllWork]{
        let orders = works.filter({
            let dateComponents1 = Calendar.current.dateComponents(neeedsDateComponents, from: $0.date.start)
            return dateComponents1 == dateComponents
        })
        return orders
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.identifire, for: indexPath)
        
        if let cell = cell as? CalendarTableViewCell{
            let work = works[indexPath.row]
            cell.dayLabel.text = work.date.start.formatted(formatString: "E\ndd")
            let dateComponentsForWorkDate = Calendar.current.dateComponents(neeedsDateComponents, from: work.date.start)
            let ordersForDate = getOrders(dateComponents: dateComponentsForWorkDate)
            ordersForDate.forEach({
                let timeComponents = Calendar.current.dateComponents([.hour,.minute], from: $0.date.start)
                var eventString = ""
                if let hour = timeComponents.hour, let minute = timeComponents.minute{
                    eventString += "\(hour):\(minute) "
                }
                eventString += $0.type == .private ? "Вызов, " : "Заявка, "
                eventString += $0.comments
                
                cell.addDateEvent(event: eventString)
            })
        }
        return cell
    }
    
    
}
