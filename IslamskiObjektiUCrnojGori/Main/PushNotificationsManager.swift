//
//  PushNotificationsManager.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 21.5.23..
//

import Foundation
import UserNotifications

final class PushNotificationsManager {
    static let shared = PushNotificationsManager()
    
    private func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
//                print("Authorization request error: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(granted)
            }
        }
    }
    
    func scheduleNotification(title: String = "Islamski Objekti u Crnoj Gori", subtitle: String, date: Date) {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization { granted in
                    if granted {
                        self.createNotification(title: title, subtitle: subtitle, date: date)
                    }
                }
            case .authorized, .provisional:
                self.createNotification(title: title, subtitle: subtitle, date: date)
            default:
                print("Authorization not granted.")
            }
        }
    }
    
    private func createNotification(title: String, subtitle: String, date: Date) {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = UNNotificationSound.default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
}
