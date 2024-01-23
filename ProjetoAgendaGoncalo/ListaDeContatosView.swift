//
//  listaDeContatosView.swift
//  ProjetoAgendaGoncalo
//
//  Created by Eliseu on 28/09/2023.
//

import SwiftUI

struct ListaDeContatosView: View {
    @State private var contatos: [listaDeContatos] = []

    var body: some View {
        
        NavigationView {
            
            VStack {
                Text("AGENDA DE CONTATOS")
                    .font(.custom("Aileron", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .padding()
                    .kerning(1.5)
                    .shadow(color: .white, radius: -2, x: 0, y: -2)
                    .shadow(color: .white, radius: -1, x: 0, y: -1)
                    .shadow(color: .white, radius: 1, x: 0, y: 1)
                
                   // mostra todos os contatos que estao na base de dados da API
                List(contatos, id: \.id) { contato in
                     NavigationLink(destination: ContatoIndividualView(id: contato.id)) {
                         HStack {
                             
                             // caso nao tnha imagem carrega um icon de personagem
                             let url = URL(string: contato.picture)
                             AsyncImage(url: url) { image in
                                 image
                                     .resizable()
                                     .scaledToFill()
                                     .frame(width: 45, height: 45)
                                     .clipShape(Circle())
                             } placeholder: {
                                 Image(systemName: "person.circle.fill")
                                     .resizable()
                                     .scaledToFill()
                                     .font(.largeTitle)
                                     .frame(width: 45, height: 45)
                                     .foregroundColor(Color.gray)
                                     
                             }

                             VStack(alignment: .leading) {
                                 Text("\(contato.firstName) \(contato.lastName)")
                                     .font(.headline)
                                     .foregroundColor(Color.white)
                                     
                             }
                         }
                     }.background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black,Color.blue.opacity(0.15)]),
                            startPoint: .trailing,
                            endPoint: .leading
                        )
                    )
                     .cornerRadius(50)
                     
                }
                .padding(.horizontal, 10.0)
                .listStyle(PlainListStyle())
                //list contatos
                .onAppear() {
                    APIconfig.compartilhar.mostrarContatos { contatos in
                        if let contatos = contatos {
                            self.contatos = contatos
                        }

                    }

                }

                NavigationLink(destination: CriarContatoView()) {
                    Text("Adicionar Contato")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(Color.blue)
                } //fim navigationLink ADD CONTATO
              
                
                
            }//vstack
            .overlay(
                Text("Criado por Eliseu e Esther")
                    .font(.system(size: 5))
                    .padding(.trailing, 15.0)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white.opacity(0.5)),
                alignment: .bottomTrailing
            )
        }//navigation
    }//body
}//struct


#Preview {
    ListaDeContatosView()
}
