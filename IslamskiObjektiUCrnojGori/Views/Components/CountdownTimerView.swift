//
//  CountdownTimerView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 16.5.23..
//

import SwiftUI

struct CountdownTimerView: View {
    @State var futureDate: Date
    @State private var remainingTime = ""
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Text(remainingTime)
            .onReceive(timer) { _ in
                let calendar = Calendar.current
                let components = calendar.dateComponents([.hour, .minute, .second], from: Date(), to: self.futureDate)
                
                if let hour = components.hour, let minute = components.minute, let second = components.second {
                    self.remainingTime = String(format: "%02d:%02d:%02d", hour, minute, second)
                } else {
                    let nextDate =  CompositionRoot.shared.prayerTimesProvider.getNextPrayerTime() ?? CompositionRoot.shared.prayerTimesProvider.getNextPrayerTime()
                    if let nextDate  {
                        self.futureDate = nextDate
                        
                    } else {
                        self.timer.upstream.connect().cancel() // Stop the timer when the future date is reached
                        self.remainingTime = ""
                    }
                }
            }
    }
}

struct CountdownTimerView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownTimerView(futureDate: Date())
    }
}
