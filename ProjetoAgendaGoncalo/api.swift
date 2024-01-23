//
//  api.swift
//  ProjetoAgendaGoncalo
//
//  Created by Eliseu on 26/09/2023.
//

import Foundation

func fazerChamadaAPI() {
    // URL da API que você deseja chamar
    let apiUrl = URL(string: "https://dummyapi.io/data/v1/user?limit=10")!

    // Sua chave de API
    let apiKey = "6510effe05441a40ae9d58cb"


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
                print("Resposta da API:")
                print(jsonString)
            }
        }
    }

    // Inicia a tarefa
    task.resume()
}


