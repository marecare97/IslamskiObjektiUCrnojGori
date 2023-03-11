//
//  ReportProblemView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 7.3.23..
//

import SwiftUI
import Combine

struct ReportProblemView: View {
    typealias S = TK.ReportProblem
    @State var email = ""
    @State var comment = ""
    @ObservedObject var viewModel = ViewModel()
    let object: ObjectDetails
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 20) {
                Text(UUID().uuidString)
                
                Text(S.yourEmail)
                
                TextField("", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                
                Text(S.comment)
                
                TextField("", text: $comment, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(8, reservesSpace: true)
                
                
                HStack {
                    Button(S.send) {
                        viewModel.reportAProblem(objectID: object.id, email: email, comment: comment)
                    }
                    .foregroundColor(.white)
                    .frame(width: 100, height: 30)
                    .background(Color.green.opacity(viewModel.isSending ? 0.5 : 1))
                    .cornerRadius(12)
                    .disabled(viewModel.isSending)
                    
                    Spacer()
                }
            }
            .background(Color.white)
            .padding()
            
            Spacer()
        }

    }
}

extension ReportProblemView {
    final class ViewModel: ObservableObject {
        @Published var isSending = false
        private var cancellable: AnyCancellable? = nil
        
        func reportAProblem(objectID: Int, email: String, comment: String) {
            cancellable = CompositionRoot.shared.reportProblemProvider.reportProblem(
                objectID: objectID,
                email: email,
                comment: comment
            )
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { _ in
                print("Success")
            })
        }
    }
}
