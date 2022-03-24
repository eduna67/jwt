import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'dart:developer' as developer;

main() async {
  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 4040);
  server.listen((event) async {
    if (event.uri.path == '/login') {
      event.response.write(_gerandoWJT());
    } else if (event.uri.path == '/teste') {
      event.response.write("teste");
    } else {
      event.response.statusCode = HttpStatus.notFound;
      event.response.write("Pagina não encontrada.");
    }
    // var body = await event.request.transform(utf8.decoder).join();
    // developer.log(body);
    // var json = jsonDecode(body);
    // developer.log(json['email']);
    // developer.log(json['senha']);
    // event.response.write('ok');

    // if (event.request.method == 'POST') {
    //   var body = await event.request.transform(utf8.decoder).join();
    //   developer.log(body);
    //   var json = jsonDecode(body);
    //   var token = json['token'];
    //   var secret = json['secret'];
    //   var algorithm = json['algorithm'];
    //   var signature = json['signature'];
    //   var verified = verify(token, signature, secret, algorithm);
    //   var response = {
    //     'verified': verified,
    //     'token': token,
    //     'signature': signature,
    //     'secret': secret,
    //     'algorithm': algorithm
    //   };
    //   developer.log(response);
    //  event.response.write(jsonEncode(response));
    //}
    await event.response.close();
  });
}

String _gerandoWJT() {
  // Montando o JSON do header do JWT
  var header = {"alg": "HS256", "typ": "JWT"};
  String header64 = base64.encode(jsonEncode(header).codeUnits);
  //print(header64);

  // Informações publicas do cliente não utilizar dados secretos.
  // idUsurio, nome, email, data de expiração do cliente por exemplo
  // "sub": "1234567890" // id do usuário
  // "name": "John Doe" // nome do usuário
  // "email": "email_do_cliente@email.com"
  // "exp": "1300819380" // data de expiração do cliente. String exp = (DateTime.now().millisecondsSinceEpoch + 60000).toString();
  // Para calcular a data de expiração do token utilizar a DateTime.now().millisecondsSinceEpoch que retorna o tempo de agora em milesegundos
  // somando + 60000 que = a um minuto em segundos, isso vai gerar um tempo de expiração de 1 minuto
  String nome = 'eduardo';
  String id = '1234567890';
  String exp = (DateTime.now().millisecondsSinceEpoch + 60000).toString();

  var payload = {"sub": id, "name": nome, "exp": exp};
  String payload64 = base64.encode(jsonEncode(payload).codeUnits);
  //print("$header64.$payload64");
  developer.log('$header64.$payload64', name: 'Meu log:');
  //developer

  // Chave secreta, isso deve ser criptografado.
  // Use a extensão do dart:crypto para gerar uma chave secreta.
  // Gravar em um arquivo ou banco de dados.
  // Não deve ser exposta ao público.
  // Manter em uma variavel de ambiente.

  // Assinatura do JWT
  var secret = 'totalsoft';
  var hmac = Hmac(sha256, secret.codeUnits);
  var signTMP = hmac.convert('$header64.$payload64'.codeUnits);
  String sign = base64.encode(signTMP.bytes);
  //print("$header64.$payload64.$sign");
  developer.log('$header64.$payload64.$sign', name: 'Meu log:');
  return '$header64.$payload64.$sign';
  
}
