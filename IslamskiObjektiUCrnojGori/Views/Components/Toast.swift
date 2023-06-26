//
//  Toast.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Marko Sentivanac on 26.6.23..
//

import SwiftUI

struct ToastNotificationModifier: ViewModifier {
    @Binding var status: Toast.State
    
    @State var task: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        ZStack {
            content
            switch status {
            case .show:
                notificaitonView
                    .padding()
                    .animation(.easeInOut(duration: 0.8))
                    .transition(
                        AnyTransition
                            .move(edge: .bottom)
                            .combined(with: .opacity)
                    )
                    .onTapGesture {
                        withAnimation {
                            self.status = .hide
                        }
                    }
                    .onAppear {
                        let task = DispatchWorkItem {
                            withAnimation {
                                self.status = .hide
                            }
                        }
                        
                        self.task = task
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: task)
                    }
                    .onDisappear {
                        self.task?.cancel()
                    }
            case .hide: EmptyView()
            }
        }
    }
    
    var notificaitonView: some View {
        VStack {
            if case .show(let data) = status {
                Spacer()
                HStack(alignment: .top, spacing: 5) {
                    data.icon
                        .padding(.leading, 15)
                        .padding(.top, 15)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(data.description)
                            .font(RFT.medium.swiftUIFont(size: 14))
                    }
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 20))
                }
                .foregroundColor(.white)
                .background(data.color)
                .cornerRadius(8)
            }
        }
    }
}

extension View {
    func toast(
        _ status: Binding<Toast.State>
    ) -> some View {
        self.modifier(
            ToastNotificationModifier(status: status)
        )
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello World")
            .toast(
                .constant(
                    .show(.error("Something went wrong"))
                )
            )
    }
}

enum Toast {
    enum State: Equatable {
        case hide
        case show(NotificationType)
    }
    
    enum NotificationType: Equatable {
        case error(String)
        case success(String?)
        case warning
        case info(String?)
        
        var color: Color {
            switch self {
            case .error:
                return .red
            case .success:
                return .green
            case .warning:
                return .yellow
            case .info:
                return .blue
            }
        }
        
        var description: String {
            switch self {
            case .error(let description):
                return description
            case .success(let desc):
                return desc ?? "success"
            case .warning:
                return "warning"
            case .info(let desc):
                return desc ?? "info"
            }
        }
        
        var icon: Image {
            switch self {
            case .error:
                return Image(systemSymbol: .multiplyCircle)
            case .success:
                return Image(systemSymbol: .checkmarkCircle)
            case .warning:
                return Image(systemSymbol: .exclamationmarkTriangle)
            case .info:
                return Image(systemSymbol: .infoCircle)
            }
        }
    }
}
