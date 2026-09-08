//
//  UserNotif.swift
//  Kara
//
//  Created by Jessica Evangeline Winardy on 08/09/26.
//

import UserNotifications

func scheduleDueNotification(for salesNote: SalesNote){
    
    guard let dueAt = salesNote.dueAt, salesNote.status != .paid
    else{
        return
    }
    
    let content = UNMutableNotificationContent()
    let formattedDateString = salesNote.dueAt?.formattedDate() ?? "-"
    content.title = "Ada Tagihan Jatuh Tempo Hari Ini!"
    content.body = "Pelanggan \(salesNote.customerName) memiliki tagihan yang harus dibayar sebesar \((salesNote.totalAmount-salesNote.paidAmount).toIDR) pada \(formattedDateString)."
    content.sound = .default
    
    var calendar = Calendar.current
    calendar.timeZone = TimeZone.current
    var dateComponents = calendar.dateComponents(
        [.year, .month, .day],
        from: dueAt
    )
    
    dateComponents.hour = 8
    dateComponents.minute = 0
    
    let trigger = UNCalendarNotificationTrigger(
        dateMatching: dateComponents,
        repeats: false
    )
    
    let request = UNNotificationRequest(
        identifier: salesNote.id.uuidString,
        content: content,
        trigger: trigger
    )
    
    UNUserNotificationCenter.current().add(request){
        error in
        if let error = error {
            print("Gagal menjadwalkan notifikasi: \(error)")
        } else{
            print(
                "Berhasil menjadwalkan notifikasi untuk: \(salesNote.customerName)"
            )
        }
    }
}
