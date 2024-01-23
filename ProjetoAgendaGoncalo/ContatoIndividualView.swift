//
//  ContatoIndividual.swift
//  ProjetoAgendaGoncalo
//
//  Created by Eliseu on 28/09/2023.
//

import SwiftUI



struct ContatoIndividualView: View {
    @Environment(\.presentationMode) var mostrarContatoIndividual  //puxar no botao de excluir, para quando o botao for selecionado, o modo apresentacao fica false e volte a pag anterior.
    
    var id: String
    
    @State private var contato: Contato?
    

    var body: some View {
        
            VStack{

                if let contato = contato {
                    
                        
                    ZStack {
                        
        
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black,Color.blue.opacity(0.23)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .edgesIgnoringSafeArea(.all)
                        .frame(height: 250)
                        
                        
                        AsyncImage(url: URL(string: "https://encurtador.com.br/fzLY4")) { image in image
                                .resizable()
                                .scaledToFill()  // imagem pra preencher todo espaço
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                
                        } placeholder: {
                            ProgressView()  // exibir enquanto a imagem esta carregando
                        }

                        
                        //exibir as imagens da API sao puxadas atraves da URL na variavel picture
                        if let url = URL(string: contato.picture), let data = try? Data(contentsOf: url) {

                            
                            Image(uiImage: UIImage(data: data) ?? UIImage())
                                .resizable()
                                .scaledToFill()  // imagem pra preencher todo espaço
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 4))  // borda
                        }
                    }//ZStack
                   
            
                        List{
                            Section(header: Text("Informações do Contato").font(.headline).frame(maxWidth: .infinity, alignment: .center)) {
                                HStack {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.blue)
                                        .imageScale(.large)
                                    VStack(alignment: .leading) {
                                        Text("Nome")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text((contato.firstName) + " " + (contato.lastName))
                                        
                                    }
                                    Spacer()
                                }
                                .padding()
                                HStack {
                                    Image(systemName: "envelope.fill")
                                        .foregroundColor(.blue)
                                        .imageScale(.large)
                                    VStack(alignment: .leading) {
                                        Text("Email")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text((contato.email))
                                        
                                    }
                                    Spacer()
                                }
                                .padding()
                                HStack {
                                    Image(systemName: "phone.fill")
                                        .foregroundColor(.blue)
                                        .imageScale(.large)
                                    VStack(alignment: .leading) {
                                        Text("Telefone")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text((contato.phone))
                                        
                                    }
                                    Spacer()
                                }
                                .padding()
                            }//hstack
                            .listRowSeparator(.hidden)
                        } //list
                        .listStyle(PlainListStyle())
                    
            //inicio botao para excluir contato
                    Button("Excluir") {
                        APIconfig.compartilhar.excluirContato(id: id) { resultado in
                            DispatchQueue.main.async {
                                switch resultado {
                                case .success:
                                    print("SUCESSO AO EXCLUIR")
                                    self.mostrarContatoIndividual.wrappedValue.dismiss()
                                case .failure(let erro):
                                    print("ERRO AO EXCLUIR - \(erro.localizedDescription)")
                                }
                            }
                        }
                    } //fim botao excluir

            .font(.title3)
            .foregroundColor(Color.red)
      
                } else {
                    Text("Carregando...")
                }
                
             
                            
            }//VStack

            .onAppear {
                self.consultarContato()
            }
            .navigationBarItems(trailing:
                VStack{
                    if let contato = contato { // verificacao para ver se o contato existe
                        NavigationLink(destination: EditarContatoView(contato: contato)) {
                            Text("Editar")
                        }
                    }
            })
                            
                 
            
    }//body
    
    
    
    func consultarContato() {
        APIconfig.compartilhar.consultarContato(id: id)  { resultado in
            switch resultado {
            case .success(let contato):
                self.contato = contato  //att a variável contato
            case .failure(let erro):
                print("Erro ao consultar contato: \(erro.localizedDescription)")
            }
        }
    } // fim func consultarContato

    
}//struct
