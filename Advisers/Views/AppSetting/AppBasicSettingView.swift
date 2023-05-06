//
//  AppBasicSettingView.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/04.
//

import SwiftUI

struct AppBasicSettingView: View {
    var body: some View {
        Form {
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
            
            // TODO: APIで取得したリストを表示する
            TextField("Model", text: Binding(get: {
                UserDataManager.shared.model
            }, set: {
                UserDataManager.shared.model = $0
            }))
                .padding()
                .textFieldStyle(.roundedBorder)
        }
    }
}

struct AppBasicSettingView_Previews: PreviewProvider {
    static var previews: some View {
        AppBasicSettingView()
    }
}
