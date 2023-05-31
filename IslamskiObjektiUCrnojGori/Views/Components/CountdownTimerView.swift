//
//  CountdownTimerView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 16.5.23..
//

import SwiftUI

struct CountdownTimerView: View {
    @Binding var targetDate: Date
    @State private var countdownString: String = ""
    
    var body: some View {
        Text(countdownString)
            .font(.subheadline)
            .onAppear {
                updateCountdownString()
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    updateCountdownString()
                }
            }
    }
    
    private func updateCountdownString() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .hour, .minute, .second], from: Date.localDate, to: targetDate)
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let currentTime = Date.localDate
        let formattedTime = dateFormatter.string(from: currentTime)
        
        //        print("Current Date \(Date.localDate), target date \(targetDate), dateFormatter time \(formattedTime)")
        
        if let hours = components.hour,
           let minutes = components.minute,
           let seconds = components.second {
            if hours == 0 && minutes == 0 && seconds == 0 {
                // Countdown reached zero, perform custom function
                performCustomFunction()
            } else {
                countdownString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            }
        }
    }
    
    private func performCustomFunction() {
        let nextDate =  CompositionRoot.shared.prayerTimesProvider.getNextPrayerTime() ?? CompositionRoot.shared.prayerTimesProvider.getNextPrayerTime()
        if let nextDate  {
            self.targetDate = nextDate
            
        }
    }
}

struct CountdownTimerView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownTimerView(targetDate: .constant(Date()))
    }
}
