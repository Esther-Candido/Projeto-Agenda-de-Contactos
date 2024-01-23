//
//  ContentView.swift
//  ProjetoAgendaGoncalo
//
//  Created by Eliseu on 24/09/2023.
//


import SwiftUI


struct CriarContatoView: View {
    @Environment(\.presentationMode) var mostrarCriarContato // para poder voltar para a pagina principal no caso de criar o usuario
    @State private var URLimagemATUAL: URL? = nil
    @State private var isEmailValid: Bool? = nil // se o email nao for valido fica vermelho

    
    
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phone = ""
   @State private var picture = ""

    @State private var contatos: [Contato] = []
    
    

    var body: some View {
        
      
            VStack {
             
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black,Color.blue.opacity(0.23)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .edgesIgnoringSafeArea(.all)
                    .frame(height: 200)
                    
                    // Plano de fundo com uma imagem sem foto
                    AsyncImage(url: URL(string: "https://encurtador.com.br/fzLY4")) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                    }

                    if let url = URLimagemATUAL {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 4))
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
                

                   
                List{
                    
                    Section(header: Text("INFORMAÇÕES DO NOVO CONTATO").font(.headline).frame(maxWidth: .infinity, alignment: .center)) {
                        
                        
                        //espaco para a "foto"
                        HStack {
                        Image(systemName: "photo.fill")
                            .foregroundColor(.blue)
                            .imageScale(.large)
                        VStack(alignment: .leading) {
                            Text("Foto (URL)")
                                .font(.caption)
                                .foregroundColor(.gray)
                            TextField("", text: $picture)
                            //para atualizar a foto ao colocar uma URl
                                .onChange(of: picture) {
                                    URLimagemATUAL = URL(string: picture)
                                }
                                .font(.caption)
                              
                        
                        }
                            Spacer()
                        }
                        .padding()
                        
                        
                        //espaco para o "Nome"
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.blue)
                                .imageScale(.large)
                            VStack(alignment: .leading) {
                                Text("Nome")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                TextField("", text: $firstName, prompt: Text("Required").font(.system(size: 7)))
                                    .font(.caption)
                                    
                             
                                
                            }
                            Spacer()
                        }
                        .padding()

                        //espaco para o "sobrenome"
                        HStack {
                            Image(systemName: "person.crop.circle")
                                .foregroundColor(.blue)
                                .imageScale(.large)
                            VStack(alignment: .leading) {
                                Text("Sobrenome")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                TextField("", text: $lastName, prompt: Text("Required").font(.system(size: 7)))
                                    .font(.caption)
                                    

                            }
                            Spacer()
                        }
                        .padding()

                        //espaco para o "email"
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(isEmailValid == false ? Color.red.opacity(0.9) : Color.blue)
                                .imageScale(.large)
                            VStack(alignment: .leading) {
                                Text("Email")  //isso ta na regra da Dummy API
                                    .font(.caption)
                                    
                                .foregroundColor(.gray)
                            TextField("", text: $email, prompt: Text("Required").font(.system(size: 7)))
                                .font(.caption)
                            }
                            Spacer()
                        }
                        .padding()
                        
                        //espaco para o "telefone"
                        HStack {
                            
                            Image(systemName: "phone.fill")
                                .foregroundColor(.blue)
                                .imageScale(.large)
                            VStack(alignment: .leading) {
                                Text("Telefone")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                TextField("", text: $phone, prompt: Text("Required").font(.system(size: 7)))
                                    .font(.caption)

                            }
                            Spacer()
                        }
                        .padding()
                    }//section
            
                } //list
               
                
                
                
                
                
        
                Button("Criar") {
                    APIconfig.compartilhar.adicionarContato(
                        firstName: self.firstName,
                        lastName: self.lastName,
                        email: self.email,
                        phone: self.phone,
                        picture: self.picture
                        
                    ) { resultado in
                        switch resultado {
                        case .success():
                            self.mostrarCriarContato.wrappedValue.dismiss()  // Voltar para a página anterior
                        case .failure(let erro):
                            
                            if APIconfig.compartilhar.isValidEmailAddr(strToValidate: email) {
                                        isEmailValid = true
                                    } else {
                                        isEmailValid = false
                                    }
                            print(erro)
                        }
                    }
                }//botao criar contato
                .font(.title3)
                .foregroundColor(Color.blue)
               
                
            }//VStack geral
            
            
        
    }//body

}//struct
