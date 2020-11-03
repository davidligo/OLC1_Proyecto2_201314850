
function crearToken(valor, tipo, fila, columna){
    this.valor = valor;
    this.tipo = tipo;
    this.fila = fila;
    this.columna = columna;
}

function crearErrorL(descripcion, fila, columna){
    this.descripcion = descripcion;
    this.fila = fila;
    this.columna = columna;
}

function esPalabraReservada(valor){
    if (valor == "public"){
        return 1;
    }else if (valor == "class"){
        return 2;
    }else if (valor == "interface"){
        return 3;
    }else if (valor == "void"){
        return 4;
    }else if (valor == "for"){
        return 5;
    }else if (valor == "while"){
        return 6;
    }else if (valor == "System"){
        return 7;
    }else if (valor == "out"){
        return 8;
    }else if (valor == "println"){
        return 9;
    }else if (valor == "do"){
        return 10;
    }else if (valor == "true"){
        return 11;
    }else if (valor == "false"){
        return 12;
    }else if (valor == "if"){
        return 13;
    }else if (valor == "else"){
        return 14;
    }else if (valor == "break"){
        return 15;
    }else if (valor == "continue"){
        return 16;
    }else if (valor == "return"){
        return 17;
    }else if (valor == "int"){
        return 18;
    }else if (valor == "boolean"){
        return 19;
    }else if (valor == "double"){
        return 20;
    }else if (valor == "string"){
        return 21;
    }else if (valor == "char"){
        return 22;
    }else if (valor == "static"){
        return 23;
    }else if (valor == "print"){
        return 24;
    }else{
        return 53;
    }
}


function analizarLexico(contenido){
    var estado = 0;
    var fila = 1;
    var columna = 0;
    var tamanioContenido = len(contenido);
    var valor = "";
    var inicioValorColum = 0;
    var inicioValorFila = 0;
    var tipovalor = 0;
    var x=0;
    let listaTokens = [];
    let listaErroresL = [];
    //contadorError = 1
    while (x <tamanioContenido){
        

        if (estado == 0){
            valor = "";
            tipovalor = 0;
            inicioValorColum = columna;
            inicioValorFila = fila;
            if (contenido[x] == '/'){
                estado = 1 ;
                columna = columna + 1;
                valor = valor + contenido[x];
            }else if (contenido[x] == '='){
                estado = 20
                columna = columna + 1;
                valor = valor + contenido[x] ;  
            }else if (contenido[x] == '"') {  // cadena 1
                estado = 5;
                columna = columna + 1;
                valor = valor + contenido[x];
            }else if (contenido[x] == '\''){  // cadena 2
                estado = 7;
                columna = columna + 1;
                valor = valor + contenido[x]   ;
            }else if (contenido[x] == '('){
                estado = -1;
                tipovalor = 27;
                columna = columna + 1;
                valor = valor + contenido[x];
            }else if (contenido[x] == ')'){
                estado = -1;
                tipovalor = 28;
                columna = columna + 1;
                valor = valor + contenido[x];
            }else if (contenido[x] == '{'){
                estado = -1;
                tipovalor = 25;
                columna = columna + 1;
                valor = valor + contenido[x];
            }else if (contenido[x] == '}'){
                estado = -1;
                tipovalor = 26;
                columna = columna + 1;
                valor = valor + contenido[x];
            }else if (contenido[x] == ';'){
                estado = -1;
                tipovalor = 31;
                columna = columna + 1;
                valor = valor + contenido[x];
            }else if (contenido[x] == '.'){
                estado = -1;
                tipovalor = 30;
                columna = columna + 1;
                valor = valor + contenido[x]; 
            }else if (contenido[x] == ','){
                estado = -1;
                tipovalor = 29;
                columna = columna + 1;
                valor = valor + contenido[x] ; 
            }else if (contenido[x] == '^'){
                estado = -1;
                tipovalor = 35;
                columna = columna + 1;
                valor = valor + contenido[x] ;     
            }else if (contenido[x] == '+'){
                estado = 21;
                columna = columna + 1;
                valor = valor + contenido[x];
            }else if (contenido[x] == '-'){
                estado = 22;
                columna = columna + 1;
                valor = valor + contenido[x] ;  
            }else if (contenido[x] == '*'){
                estado = -1;
                tipovalor = 45;
                columna = columna + 1;
                valor = valor + contenido[x];                  
            }else if (contenido[x] == '!'){
                estado = 23;
                columna = columna + 1;
                valor = valor + contenido[x] ; 
            }else if (contenido[x] == '>'){
                estado = 24;
                tipovalor = 6;
                columna = columna + 1;
                valor = valor + contenido[x] ;
            }else if (contenido[x] == '<'){
                estado = 25;
                columna = columna + 1;
                valor = valor + contenido[x]  ;                              
            }else if (contenido[x] == '&'){
                estado = 9;
                columna = columna + 1;
                valor = valor + contenido[x] ;
            }else if (contenido[x] == '|'){  
                estado = 10;
                columna = columna + 1;
                valor = valor + contenido[x];
            }else if (contenido[x] == '['){
                estado = -1;
                tipovalor = 49;
                columna = columna + 1;
                valor = valor + contenido[x]; 
            }else if (contenido[x] == ']'){
                estado = -1;
                tipovalor = 50;
                columna = columna + 1;
                valor = valor + contenido[x];   
            }else if ((contenido[x] >= 'A' && contenido[x] <= 'Z') || (contenido[x] >= 'a' && contenido[x] <= 'z')){ // posible palabra o identificador
                estado = 11;
                columna = columna + 1;
                valor = valor + contenido[x];
            }else if (contenido[x] >= '1' && contenido[x] <= '9'){ // posible numero
                estado = 13;
                columna = columna + 1;
                valor = valor + contenido[x]   ;
            }else if (contenido[x] == '0'){ // posible valor 0
                estado = 15;
                columna = columna + 1;
                valor = valor + contenido[x] ;
            }else if (contenido[x] == ' '){
                columna = columna + 1;    
                texto.insert(END, " ")
            }else if (contenido[x] ==  '\t'){
                columna = columna + 1;
                texto.insert(END, "\t")
            }else if (contenido[x] == '\n'){
                columna = 0;
                fila = fila + 1;
                texto.insert(END, "\n")
            }else if  (contenido[x] ==  '\r'){
                pass 
            }else{
                estado = -2;
                columna = columna + 1;
                valor = valor + contenido[x];
            }              
        }else if (estado == 1)  { //   /
            if (contenido[x] == '/'){  // comentario de 1 linea
                estado = 2;
                columna = columna + 1;
                valor = valor + contenido[x];
            }else if (contenido[x] == '*'){ // comentario multilinea
                estado = 3;
                columna = columna + 1;
                valor = valor + contenido[x];
            }else{
                estado = -1; // aceptacion para simbolo / que seria un operador
                tipovalor = 46;
                x=x-1; // regresamos en 1 para volver a leer el simbolo 
            }               
        }else if (estado == 2){ // comentario de 1 linea
            if (contenido[x] == '\n'){  // comentario de 1 linea
                estado = -1;
                tipovalor = 51;
                x=x-1;                           
            }else{
                columna = columna + 1;
                valor = valor + contenido[x];
            } 
        }else if (estado == 3){ // comentario multilinea
            if (contenido[x] == '*'){  // posible salida
                estado = 4;
                columna = columna + 1;
                valor = valor + contenido[x];               
            }else{
                if (contenido[x] == '\n'){
                    columna = 0;
                    fila = fila + 1;
                }else{
                    columna = columna + 1;
                }
                valor = valor + contenido[x];
            }   
        }else if (estado == 4){ // comentario multilinea posible salida
            if (contenido[x] == '/'){  // salida
                estado = -1;  
                columna = columna + 1;
                tipovalor = 52;
                valor = valor + contenido[x];
            }else if (contenido[x] == '*'){  // posible salida
                columna = columna + 1;
                valor = valor + contenido[x];                
            }else{
                estado = 3;
                if (contenido[x] == '\n'){
                    columna = 0;
                    fila = fila + 1;
                }else{
                    columna = columna + 1;
                }                
                valor = valor + contenido[x];
            }
        }else if (estado == 5){   //   posible cadena
            if (contenido[x] == '\\'){  // posible uso de \"
                estado = 6;
                columna = columna + 1;
                valor = valor + contenido[x];
            }else if (contenido[x] == '"'){ // fin y aceptacion de cadena
                estado = -1;
                columna = columna + 1;
                tipovalor = 51;               
                valor = valor + contenido[x];
            }else if (contenido[x] == '\n'){  //salto de linea es porque hay error
                estado = -2;
                x=x-1;
            }else{
                columna = columna + 1;
                valor = valor + contenido[x];
            }
        }else if (estado == 6){
            if (contenido[x] == '\n'){  //salto de linea es porque hay error
                estado = -2;
                x=x-1;     
            }else{
                columna = columna + 1;
                valor = valor + contenido[x];
                estado = 5;
            }
        }else if (estado == 7){    //   posible cadena
            if (contenido[x] == '\\'){  // posible uso de \'
                estado = 8;
                columna = columna + 1;
                valor = valor + contenido[x];
            }else if (contenido[x] == '\''){// fin y aceptacion de cadena
                estado = -1;
                columna = columna + 1;
                tipovalor = 52;              
                valor = valor + contenido[x];
            }else if (contenido[x] == '\n'){ // salto de linea es porque hay error
                estado = -2;
                x=x-1;
            }else{
                columna = columna + 1;
                valor = valor + contenido[x];
            }
        }else if (estado == 8){
            if (contenido[x] == '\n'){  //salto de linea es porque hay error
                estado = -2;
                x=x-1;     
            }else{
                columna = columna + 1;
                valor = valor + contenido[x];
                estado = 7;
            }    
        }else if (estado == 9){
            if (contenido[x] == '&'){  // aceptacion de &&
                estado = -1;
                columna = columna + 1;
                valor = valor + contenido[x];
                tipovalor = 32;
            }else{  // error 
                estado = -2;
                x=x-1;
            }      
        }else if (estado == 10){
            if (contenido[x] == '|'){  // aceptacion de ||
                estado = -1;
                columna = columna + 1;
                valor = valor + contenido[x];
                tipovalor = 33;
            }else{ // error 
                estado = -2;
                x=x-1;       
            }
        }else if (estado == 11){  // posible palabra o identificador
            if ((contenido[x] >= 'A' && contenido[x] <= 'Z') && (contenido[x] >= 'a' && contenido[x] <= 'z')){ // sigo en posible palabra o identificador
                columna = columna + 1;
                valor = valor + contenido[x];  //48 - 57
            }else if (contenido[x] >= '0' && contenido[x] <= '9'){ // numero entonces es identificador
                estado = 12;
                columna = columna + 1;
                valor = valor + contenido[x];
            }else if (contenido[x] == '_'){ // _ entonces es identificador
                estado = 12;
                columna = columna + 1;
                valor = valor + contenido[x];                 
            }else{  // acepta la palabra reservada o posible identificador
                estado = -1;
                tipovalor = esPalabraReservada(valor);
                x=x-1;
            }    
        }else if (estado == 12){ // es un identificador si o si
            if ((contenido[x] >= 'A' && contenido[x] <= 'Z') && (contenido[x] >= 'a' && contenido[x] <= 'z')){ // sigo en posible palabra o identificador
                columna = columna + 1;
                valor = valor + contenido[x];  
            }else if (contenido[x] >= '0' && contenido[x] <= '9'){ 
                columna = columna + 1;
                valor = valor + contenido[x];
            }else if (contenido[x] == '_'){ // _ entonces es identificador
                columna = columna + 1;
                valor = valor + contenido[x];                 
            }else{  // acepta el identificador
                estado = -1;
                tipovalor = 53;
                x=x-1;
            }  
        }else if (estado == 13){ // posible numero
            if (contenido[x] >= '0' && contenido[x] <= '9'){ // numero, me quedo en numero
                columna = columna + 1;
                valor = valor + contenido[x];
            }else if (contenido[x] == '.'){ // . entonces es numero con decimales
                estado = 14;
                columna = columna + 1;
                valor = valor + contenido[x];
            }else{  // aceptamos numero
                estado = -1;
                tipovalor = 54;
                x=x-1;
            } 
        }else if (estado == 14){ // posible numero con decimales
            if (contenido[x] >= '0' && contenido[x] <= '9'){ // numero entonces es numero con decimales
                columna = columna + 1;
                estado = 19;
                valor = valor + contenido[x];            
            }else{}  // acepta el numero sin el .
                estado = -1
                tipovalor = 54;
                columna = columna - 1;
                x=x-2;
                valor.replace('.','');
        }else if (estado == 19){ // numero con decimales
            if (contenido[x] >= '0' && contenido[x] <= '9'){ // numero
                columna = columna + 1;
                valor = valor + contenido[x];               
            }else{  // acepta el numero con decimales
                estado = -1;
                tipovalor = 54;
                x=x-1; 
            }      
        }else if (estado == 15){ // posible numero 0
            if (contenido[x] == '.'){ // . posible 0. algo
                estado = 16;
                columna = columna + 1;
                valor = valor + contenido[x];            
            }else if (contenido[x] >= '0' && contenido[x] <= '9'){ // es un 054687 o algo similar que seria un error
                estado = 18;
                columna = columna + 1;
                valor = valor + contenido[x];       
            }else{  // acepta 0
                estado = -1;
                tipovalor = 54;
                x=x-1;
            }    
        }else if (estado == 16){ // posible numero
            if (contenido[x] >= '0' && contenido[x] <= '9'){ // numero entonces es 0.5 o algo similar
                estado = 17;
                columna = columna + 1;
                valor = valor + contenido[x] ;                 
            }else{  // acepta el 0 y el . por separado
                estado = -1;
                tipovalor = 54;
                columna = columna - 1;
                x=x-2;
                valor = "0";
            }                
        }else if (estado == 17){ // posible numero 0.654
            if (contenido[x] >= '0' && contenido[x] <= '9'){ // numero entonces es identificador
                columna = columna + 1;
                valor = valor + contenido[x];
            }else{  // acepta el 0.6546
                estado = -1;
                tipovalor = 4;
                x=x-1;
            }            
        }else if (estado == 18){
            if (contenido[x] >= '0' && contenido[x] <= '9'){ // siguen siendo numeros y los acpetamos para el error
                columna = columna + 1;
                valor = valor + contenido[x];
            }else{  // aceptamos toda la cadena como error
                estado = -2
                x=x-1   
            }  
        }else if (estado == 20){
            if (contenido[x] == '='){  // aceptacion de ==
                estado = -1;
                columna = columna + 1;
                valor = valor + contenido[x];
                tipovalor = 41;
            }else{  // aceptamos solo el = 
                estado = -1;
                tipovalor = 38;
                x=x-1;
            }      
        }else if (estado == 21){
            if (contenido[x] == '+'){  // aceptacion de ++
                estado = -1;
                columna = columna + 1;
                valor = valor + contenido[x];
                tipovalor = 47;
            }else{  // aceptamos solo el = 
                estado = -1;
                tipovalor = 43;
                x=x-1;
            } 
        }else if (estado == 22){
            if (contenido[x] == '-'){  // aceptacion de --
                estado = -1;
                columna = columna + 1;
                valor = valor + contenido[x];
                tipovalor = 48;
            }else{  // aceptamos solo el = 
                estado = -1;
                tipovalor = 44;
                x=x-1;
            } 
        }else if (estado == 23){
            if (contenido[x] == '='){  // aceptacion de !=
                estado = -1;
                columna = columna + 1;
                valor = valor + contenido[x];
                tipovalor = 42;
            }else{  // aceptamos solo el ! 
                estado = -1;
                tipovalor = 34;
                x=x-1;
            } 
        }else if (estado == 24){
            if (contenido[x] == '='){  // aceptacion de >=
                estado = -1;
                columna = columna + 1;
                valor = valor + contenido[x];
                tipovalor = 39;
            }else{  // aceptamos solo el > 
                estado = -1;
                tipovalor = 36;
                x=x-1;
            }    
        }else if (estado == 25){
            if (contenido[x] == '='){  // aceptacion de <=
                estado = -1;
                columna = columna + 1;
                valor = valor + contenido[x];
                tipovalor = 40;
            }else{  // aceptamos solo el < 
                estado = -1;
                tipovalor = 37;
                x=x-1;
            }    
        }else if (estado == -1){   //estado de aceptacion para todos
            var nuevoToken = new crearToken(valor, tipovalor, inicioValorFila, inicioValorColum);
            listaTokens.push(nuevoToken);
            valor = ""  
            tipovalor = 0
            estado = 0
            x=x-1
        }else if (estado == -2){      // estado de errores
            var nuevoError = new crearErrorL("El caracter "+ valor + " no pertenece al lenguaje.", inicioValorFila, inicioValorColum);
            listaErroresL.push(nuevoError);
            valor = ""  
            estado = 0
            x=x-1  
        }          
        x += 1  
    }
    if (estado != 0){
        var nuevoError = new crearErrorL("La cadena "+ valor + " no pertenece al lenguaje.", inicioValorFila, inicioValorColum);
        listaErroresL.push(nuevoError);
        valor = ""  
        estado = 0
        x=x-1 
    }      

}