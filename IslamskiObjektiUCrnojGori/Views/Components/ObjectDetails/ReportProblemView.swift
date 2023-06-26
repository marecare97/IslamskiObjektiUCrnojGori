//
//  ReportProblemView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 7.3.23..
//

import SwiftUI
import Combine
import SSToastMessage

struct ReportProblemView: View {
    typealias S = TK.ReportProblem
    @State var email = ""
    @State var comment = ""
    @FocusState private var emailIsFocused: Bool
    @FocusState private var commentIsFocused: Bool
    @StateObject var viewModel = ViewModel()
    let object: ObjectDetails
    
    var body: some View {
        VStack {
            CustomNavBar(navBarTitle: S.title)
            contentView
                .onTapGesture {
                    emailIsFocused = false
                    commentIsFocused = false
                }
                .padding([.vertical, .horizontal])
        }
        .toast($viewModel.toast)
        .navigationBarBackButtonHidden()
    }
    
    var contentView: some View {
        VStack {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Spacer()
                    Text(object.name)
                        .font(RFT.bold.swiftUIFont(size: 20))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .padding(.horizontal)
                
                Text(S.yourEmail)
                    .font(PFT.semiBold.swiftUIFont(size: 16))
                    .foregroundColor(.black)
                
                TextField("", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($emailIsFocused)
                
                
                Text(S.comment)
                    .font(PFT.semiBold.swiftUIFont(size: 16))
                    .foregroundColor(.black)
                
                TextField("", text: $comment, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($commentIsFocused)
                    .lineLimit(8, reservesSpace: true)
                
                
                HStack {
                    Button(S.send) {
                        viewModel.reportAProblem(objectID: object.id, email: email, comment: comment)
                    }
                    .foregroundColor(.white)
                    .frame(width: 100, height: 30)
                    .background(Color.green.opacity(viewModel.isSending || viewModel.hasReportedSuccessfully ? 0.5 : 1))
                    .cornerRadius(12)
                    .disabled(viewModel.isSending || viewModel.hasReportedSuccessfully)
                    
                    Spacer()
                }
            }
            .padding()
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray, lineWidth: 1)
            )
            
            
            Spacer()
        }
    }
}

extension ReportProblemView {
    final class ViewModel: ObservableObject {
        @Published var isSending = false
        @Published var hasReportedSuccessfully = false
        private var cancellable: AnyCancellable? = nil
        @Published var toast: Toast.State = .hide
        
        func reportAProblem(objectID: Int, email: String, comment: String) {
            cancellable = CompositionRoot.shared.reportProblemProvider.reportProblem(
                objectID: objectID,
                email: email,
                comment: comment
            )
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { [weak self] _ in
                self?.toast = .show(.success("Problem uspješno prijavljen."))
                self?.hasReportedSuccessfully = true
            })
        }
    }
}
