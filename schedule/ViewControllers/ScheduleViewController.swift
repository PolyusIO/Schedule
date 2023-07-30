//
//  ScheduleViewController.swift
//  schedule
//
//  Created by Сергей Поляков on 30.07.2023.
//

import UIKit

enum UrlBit: String {
    case nose = "https://www.usue.ru/schedule/?action=show&startDate="
    case middle = "&endDate="
    case tail = "&group=%D0%9E%D0%97%D0%9C-%D0%9A%D0%98%D0%A1-22-2"
}

final class ScheduleViewController: UITableViewController {
    
    // MARK: - Private Properties
    private let reuseIdentifier = "day"
    
    private var schedule: [DailySchedule] = []
    
    private var testUrl: String {
        UrlBit.nose.rawValue + "21.11.2022" + UrlBit.middle.rawValue + "27.11.2022" + UrlBit.tail.rawValue
    }
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSchedule()
    }
    
    // MARK: - Private Methods
    private func sortSchedule(_ schedule: [DailySchedule]) -> [DailySchedule] {
        var sortedSchedule: [DailySchedule] = []
        for day in schedule {
            var sortedPairs: [Pair] = []
            for pair in day.pairs {
                if pair.schedulePairs.count != 0 {
                    sortedPairs.append(pair)
                }
            }
            if sortedPairs.count != 0 {
                sortedSchedule.append(DailySchedule(
                    date: day.date,
                    weekDay: day.weekDay,
                    isCurrentDate: day.isCurrentDate,
                    pairs: sortedPairs)
                )
            }
        }
        return sortedSchedule
    }
}

// MARK: - Table view data source
extension ScheduleViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        schedule.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        schedule[section].pairs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = schedule[indexPath.section].pairs[indexPath.row].schedulePairs.first?.description
        content.secondaryText = schedule[indexPath.section].pairs[indexPath.row].description
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let dayLabel = UILabel(
            frame: CGRect(
                x: 16,
                y: 3,
                width: 300,
                height: 20
            )
        )
        dayLabel.text = "\(schedule[section].date)   \(schedule[section].weekDay)"
        dayLabel.font = UIFont.boldSystemFont(ofSize: 20)
        dayLabel.textColor = .white
        
        let contentView = UIView()
        contentView.addSubview(dayLabel)
        
        return contentView
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.backgroundColor = .gray
    }
}


extension ScheduleViewController {
    private func fetchSchedule() {
        guard let url = URL(string: testUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { [unowned self] data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let schedule = try jsonDecoder.decode([DailySchedule].self, from: data)
                let sortSchedule = sortSchedule(schedule)
                
                DispatchQueue.main.async {
                    self.schedule = sortSchedule
                    self.tableView.reloadData()
                }
                print(schedule)
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
