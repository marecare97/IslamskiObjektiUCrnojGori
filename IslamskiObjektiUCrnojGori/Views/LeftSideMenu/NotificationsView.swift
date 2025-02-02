//
//  NotificationsView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 7.3.23..
//

import SwiftUI
import Combine

struct NotificationsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                VStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(.circular)
                    Spacer()
                }
            case .finished:
                ZStack(alignment: .top) {
                    ScrollView(showsIndicators: false) {
                        LazyVStack {
                            ForEach(viewModel.notifications, id: \.id) { notification in
                                NotificationsListRow(notification: notification)
                                
                                if notification != viewModel.notifications.last {
                                    Divider()
                                }
                            }
                        }
                        .padding(.top, 70)
                    }
                    CustomNavBar(navBarTitle: TK.Notifications.title)
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    struct NotificationsListRow: View {
        let notification: Notifications.Notification
        
        var body: some View {
            VStack(alignment: .leading, spacing: 15) {
                HStack(alignment: .top) {
                    Text(notification.title)
                        .lineLimit(2)
                        .padding(.trailing, 20)
                    
                    Spacer()
                    
                    Text(notification.date)
                }
                
                Text(notification.content)
                    .bold()
            }
            .padding()
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}

extension NotificationsView {
    final class ViewModel: ObservableObject {
        private var cancellable: AnyCancellable? = nil
        @Published var state: State = .loading
        @Published var notifications = [Notifications.Notification]()
        
        enum State {
            case loading
            case finished
        }
        
        init() {
            fetchNotifications()
        }
        
        func fetchNotifications() {
            state = .loading
            cancellable = CompositionRoot.shared.notificationsProvider.fetchNotifications()
                .sink(receiveCompletion: { _ in
                    
                }, receiveValue: { notifications in
                    self.notifications = notifications.message
                    self.state = .finished
                })
        }
    }
}
