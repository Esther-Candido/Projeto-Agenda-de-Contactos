//
//  ViewModell.swift
//  ProjetoAgendaGoncalo
//
//  Created by Eliseu on 27/09/2023.
//

//
//  ViewModel.swift
//  ProjetoAgendaGoncalo
//
//  Created by Eliseu on 26/09/2023.
//

import Foundation

class ViewModell: ObservableObject {
    @Published var apiResponse: String = ""

    func fazerChamadaAPI() {
        // URL da API que você deseja chamar
        let apiUrl = URL(string: "https://dummyapi.io/data/v1/user/60d0fe4f5311236168a109ca")!

        // Sua chave de API
        let apiKey = "ML5M-EPXG-G6O3-3P2Y"

        // Cria uma configuração de sessão
        let config = URLSessionConfiguration.default

        // Adiciona a chave de API aos cabeçalhos da requisição
        config.httpAdditionalHeaders = ["Authorization": "Bearer \(apiKey)"]

        // Cria uma sessão URLSession com a configuração
        let session = URLSession(configuration: config)

        // Cria uma tarefa de data para fazer a requisição
        let task = session.dataTask(with: apiUrl) { (data, response, error) in
            if let error = error {
                print("Erro na requisição: \(error)")
            } else if let data = data {
                // Se a resposta foi bem-sucedida, você pode processar os dados aqui
                if let jsonString = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        self.apiResponse = jsonString
                    }
                }
            }
        }

        // Inicia a tarefa
        task.resume()
    }
}

