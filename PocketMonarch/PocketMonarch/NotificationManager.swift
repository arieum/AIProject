//
//  NotificationManager.swift
//  PocketMonarch
//
//  Created by 장유진 on 8/26/25.
//

import UserNotifications

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()

    func configure() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    func notifyHighRisk(probText: String) {
        let content = UNMutableNotificationContent()
        content.title = "🚨 보이스피싱 의심!"
        content.body  = "확률 \(probText). 통화를 즉시 중단하고 확인하세요."
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil // 즉시
        )
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    // 앱이 포그라운드일 때도 배너로 보여주기
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .list])
    }
}
