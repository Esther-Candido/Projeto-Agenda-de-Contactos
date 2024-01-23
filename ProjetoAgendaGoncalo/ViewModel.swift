import Foundation  //biblioteca que faz solicitacoes HTTP

struct listaDeContatos: Decodable{
    var id: String
    var title: String?
    var firstName: String
    var lastName: String
    var picture: String
    
}

struct Contato: Decodable {
    var id: String
    var title: String?
    var firstName: String
    var lastName: String
    var gender: String?
    var email: String
    var dateOfBirth: String?
    var registerDate: String?
    var phone: String
    var picture: String
    var location: Location?

    struct Location: Decodable {
        var street: String?
        var city: String?
        var state: String?
        var country: String?
        var timezone: String?
    }

    

}
struct listaDeContatosResponse: Decodable {
    var data: [listaDeContatos]
}


struct APIResponse: Decodable {
    var data: Contato?
    
    private enum CodingKeys: String, CodingKey {
        case data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try? container.decode(Contato.self, forKey: .data)
    }
}


class APIconfig {
    static let compartilhar = APIconfig()
    let chaveAPI = "6521e056a59bad9db7920df9"
    
    //func para mostrar uma lista de contato
    func mostrarContatos(verificar: @escaping ([listaDeContatos]?) -> Void) {
        //essa url puxa os usuarios de exemplo que estao na api da Dummy
        //let url = URL(string: "https://dummyapi.io/data/v1/user?page=3limit=999")!
        
        //essa url fica de acordo com a documentacao da Dummy onde puxa apenas a lista de usuarios criados por nos.
        let url = URL(string: "https://dummyapi.io/data/v1/user?created=1")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(chaveAPI, forHTTPHeaderField: "app-id")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let listaContatos = try decoder.decode(listaDeContatosResponse.self, from: data)
                    verificar(listaContatos.data)
                   
                } catch {
                    print("Erro ao analisar o JSON: \(error)")
                    verificar(nil)
                }
            } else if let error = error {
                print("Erro na solicitação HTTP: \(error.localizedDescription)")
                verificar(nil)
            } else {
                print("Erro desconhecido ao consultar contatos")
                verificar(nil)
            }
        }.resume()
    }

    
    
    //func para criar um contato.. na documentacao da api, fica obrigatorio (nome, sobrenome e email)
    func adicionarContato(firstName: String, lastName: String, email: String, phone: String ,picture: String, verificar: @escaping (Result<Void, APIErro>) -> Void) {
        let url = URL(string: "https://dummyapi.io/data/v1/user/create")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"   //metodo http para criar novos dados de um objeto na api
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(chaveAPI, forHTTPHeaderField: "app-id")

        let usuario = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "phone": phone,
            "picture": picture
        ]

        do {
            let jsonData = try JSONEncoder().encode(usuario)
            request.httpBody = jsonData

        } catch {
            print("Erro ao criar dados JSON: \(error)")
            verificar(.failure(.erroDesconhecido))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
               DispatchQueue.main.async {
                   if let httpResponse = response as? HTTPURLResponse {
                       if httpResponse.statusCode == 200 {
                           verificar(.success(()))
                       } else {
                           // Erro ao criar usuario // possivelmente erro ao colocar o email, pois la tem que colocar o %@%.com
                           print("Erro ao criar usuario - Status: \(httpResponse.statusCode)")
                           verificar(.failure(.respostaInvalida))
                       }
                   } else if let error = error {
                       print("Erro na requisição de rede: \(error.localizedDescription)")
                       verificar(.failure(.erroDesconhecido))
                   } else {
                       print("Erro desconhecido ao criar usuario")
                       verificar(.failure(.erroDesconhecido))
                   }
               }
           }.resume()
            } //fim func adicionarContato

    // Func para consultar o contato pelo id
    func consultarContato(id: String, verificar: @escaping (Result<Contato, Error>) -> Void) {
        guard let url = URL(string: "https://dummyapi.io/data/v1/user/\(id)") else {
            verificar(.failure(NSError(domain: "URL invalida", code: 0)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET" // Metodo http para recuperar informacoes da api
        request.setValue(chaveAPI, forHTTPHeaderField: "app-id")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erro na solicitacao HTTP: \(error.localizedDescription)")
                verificar(.failure(error))
                return
            }

            guard let data = data else {
                print("Dados nao recebidos")
                verificar(.failure(NSError(domain: "Dados nao recebidos", code: 1)))
                return
            }

            do {
                let decoder = JSONDecoder()
                let contato = try decoder.decode(Contato.self, from: data)
                verificar(.success(contato))
            } catch {
                print("Erro ao analisar o JSON: \(error)")
                verificar(.failure(error))
            }
        }.resume()
    } // Fim func consultarContato

    
    //funcao para realizar a edicao de um [contato], onde pegamos o ID individualmente, usando as estruturas ja existentes.
    //documentacao da api diz que o email fica proibido de ser alterado.
    func editarContato(id: String, firstName: String, lastName: String, picture: String, email: String, phone: String, verificar: @escaping (Result<Void, APIErro>) -> Void){
        guard let url = URL(string: "https://dummyapi.io/data/v1/user/\(id)") else {
            // URL invalida
            verificar(.failure(.urlInvalida))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT" //metodo http para atualizar os dados
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(chaveAPI, forHTTPHeaderField: "app-id")

        let usuario = [
            "firstName": firstName,
            "lastName": lastName,
            "picture": picture,
            "email": email,
            "phone": phone
        ]

        do {
            let jsonData = try JSONEncoder().encode(usuario)
            request.httpBody = jsonData
        } catch {
            print("Erro ao criar dados JSON: \(error)")
            verificar(.failure(.erroDesconhecido))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                // Erro na requisicao de rede
                print("Erro na requisição de rede: \(error.localizedDescription)")
                verificar(.failure(.erroDesconhecido))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                // Erro ao atualizar usuário
                print("Erro ao atualizar usuário - Status: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                verificar(.failure(.respostaInvalida))
                return
            }

            //deu certo na requisicao
            verificar(.success(()))
        }

        task.resume() // Inicia a tarefa
    } //fim func editarContato

        
    enum APIErro: Error {
        case urlInvalida
        case respostaInvalida
        case erroDesconhecido
    }


    //funcao excluir um contato por ID conforme documentacao da Api da DUMMY
    func excluirContato(id: String, verificar: @escaping (Result<Void, APIErro>) -> Void) {
        guard let url = URL(string: "https://dummyapi.io/data/v1/user/\(id)") else {
            // URL invalida
            verificar(.failure(.urlInvalida))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"  // metodo http para deletar os dados da API
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(chaveAPI, forHTTPHeaderField: "app-id")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                // Erro na requisicao de rede
                print("Erro na requisicao de rede: \(error.localizedDescription)")
                verificar(.failure(.erroDesconhecido))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                // Erro ao excluir contato
                print("Erro ao excluir contato - Status: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                verificar(.failure(.respostaInvalida))
                return
            }
            
            //deu certo na requisicao
            verificar(.success(()))
        }
        
        task.resume()  // Inicia a tarefa
    }  // fim func excluirContato

    
    // Funcao esse email e valido, (nao foi feita por nos)
    func isValidEmailAddr(strToValidate: String) -> Bool {
        let emailValidationRegex = "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-]+@[\\p{L}0-9-]+\\.[\\p{L}0-9-]{2,7}$"
        let emailValidationPredicate = NSPredicate(format: "SELF MATCHES %@", emailValidationRegex)
        return emailValidationPredicate.evaluate(with: strToValidate)
    }


       

}// fim classe APIconfig
