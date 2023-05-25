//
//  AppBasicSettingView.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/04.
//

import SwiftUI

struct AppBasicSettingView: View {
    @AppStorage(UserDataManager.Keys.model.rawValue) private var selectedModel: String = "gpt-3.5-turbo"
    @State private var models: [String] = []
    
    var body: some View {
        Form {
            TextField("Your Name", text: Binding(get: {
                UserDataManager.shared.userName
            }, set: {
                UserDataManager.shared.userName = $0
            }))
                .padding()
                .textFieldStyle(.roundedBorder)
            
            TextField("Organiztion ID", text: Binding(get: {
                UserDataManager.shared.organizationId
            }, set: {
                UserDataManager.shared.organizationId = $0
            }))
                .padding()
                .textFieldStyle(.roundedBorder)
            
            TextField("API Key", text: Binding(get: {
                UserDataManager.shared.apiKey
            }, set: {
                UserDataManager.shared.apiKey = $0
            }))
                .padding()
                .textFieldStyle(.roundedBorder)
            
            Picker("Model", selection: $selectedModel) {
                ForEach(models, id: \.self) { model in
                    Text(model)
                        .font(.title2)
                        .tag(model)
                }
            }
            .padding()
        }
        .onAppear {
            models = [selectedModel]
            
            Task {
                let openAIModels = try await OpenAIClient.shared.models()
                self.models = openAIModels.data.map { $0.id }.filter { $0.contains("gpt-") }.sorted()
            }
        }
    }
}

struct AppBasicSettingView_Previews: PreviewProvider {
    static var previews: some View {
        AppBasicSettingView()
    }
}
