/**
 * Ejemplo Intérprete Sencillo con Jison utilizando Nodejs en Ubuntu
 */

 %{
	var errores_lexicos		= [];
	var errores_sintacticos 	= [];
    var listaTokens           = [];
    var textoNuevo = "";
	function ast(padre, hijos){
         this.padre = padre;
         this.hijos = hijos;
    }
	function crearErrorL(descripcion, fila, columna){
  		this.descripcion = descripcion;
  		this.fila = fila;
  		this.columna = columna;
	}
    function crearErrorS(descripcion, fila, columna){
  		this.descripcion = descripcion;
  		this.fila = fila;
  		this.columna = columna;
	}
    function crearToken(valor, tipo, fila, columna){
        this.valor = valor;
        this.tipo = tipo;
        this.fila = fila;
        this.columna = columna;
    }
    function crearRespuesta(listaTokens, lista_lexicos, lista_sintacticos, ast){
        this.listaTokens = listaTokens;
        this.lista_lexicos = lista_lexicos;
        this.lista_sintacticos = lista_sintacticos;
        this.ast = ast;
    }
%}

/* Definición Léxica */
%lex

%options case-sensitive

%%

\s+											{textoNuevo = textoNuevo + yytext;}// se ignoran espacios en blanco
"//".*										{textoNuevo = textoNuevo + yytext;}// comentario simple línea
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]			{textoNuevo = textoNuevo + yytext;}// comentario multiple líneas

"public"			{ listaTokens.push(new crearToken(yytext, "palabra reservada public", yylloc.first_line, yylloc.first_column)); return 'RPUBLIC';}
"class"				{ listaTokens.push(new crearToken(yytext, "palabra reservada class", yylloc.first_line, yylloc.first_column)); return 'RCLASS';}
"interface"			{ listaTokens.push(new crearToken(yytext, "palabra reservada interface", yylloc.first_line, yylloc.first_column)); return 'RINTERFACE';}
"void"				{ listaTokens.push(new crearToken(yytext, "palabra reservada void", yylloc.first_line, yylloc.first_column)); return 'RVOID';}
"for"				{ listaTokens.push(new crearToken(yytext, "palabra reservada for", yylloc.first_line, yylloc.first_column)); return 'RFOR';}
"while"				{ listaTokens.push(new crearToken(yytext, "palabra reservada while", yylloc.first_line, yylloc.first_column)); return 'RWHILE';}
"System"			{ listaTokens.push(new crearToken(yytext, "palabra reservada System", yylloc.first_line, yylloc.first_column)); return 'RSYSTEM';}
"out"				{ listaTokens.push(new crearToken(yytext, "palabra reservada out", yylloc.first_line, yylloc.first_column)); return 'ROUT';}
"println"			{ listaTokens.push(new crearToken(yytext, "palabra reservada println", yylloc.first_line, yylloc.first_column)); return 'RPRINTLN';}
"do"				{ listaTokens.push(new crearToken(yytext, "palabra reservada do", yylloc.first_line, yylloc.first_column)); return 'RDO';}
"true"				{ listaTokens.push(new crearToken(yytext, "palabra reservada true", yylloc.first_line, yylloc.first_column)); return 'RTRUE';}
"false"				{ listaTokens.push(new crearToken(yytext, "palabra reservada false", yylloc.first_line, yylloc.first_column)); return 'RFALSE';}
"if"				{ listaTokens.push(new crearToken(yytext, "palabra reservada if", yylloc.first_line, yylloc.first_column)); return 'RIF';}
"else"				{ listaTokens.push(new crearToken(yytext, "palabra reservada else", yylloc.first_line, yylloc.first_column)); return 'RELSE';}
"break"				{ listaTokens.push(new crearToken(yytext, "palabra reservada break", yylloc.first_line, yylloc.first_column)); return 'RBREAK';}
"continue"			{ listaTokens.push(new crearToken(yytext, "palabra reservada continue", yylloc.first_line, yylloc.first_column)); return 'RCONTINUE';}
"return"			{ listaTokens.push(new crearToken(yytext, "palabra reservada return", yylloc.first_line, yylloc.first_column)); return 'RRETURN';}
"int"				{ listaTokens.push(new crearToken(yytext, "palabra reservada int", yylloc.first_line, yylloc.first_column)); return 'RINT';}
"boolean"			{ listaTokens.push(new crearToken(yytext, "palabra reservada boolean", yylloc.first_line, yylloc.first_column)); return 'RBOOLEAN';}
"double"			{ listaTokens.push(new crearToken(yytext, "palabra reservada double", yylloc.first_line, yylloc.first_column)); return 'RDOUBLE';}
"String"			{ listaTokens.push(new crearToken(yytext, "palabra reservada String", yylloc.first_line, yylloc.first_column)); return 'RSTRING';}
"char"				{ listaTokens.push(new crearToken(yytext, "palabra reservada char", yylloc.first_line, yylloc.first_column)); return 'RCHAR';}
"static"			{ listaTokens.push(new crearToken(yytext, "palabra reservada static", yylloc.first_line, yylloc.first_column)); return 'RSTATIC';}
"print"				{ listaTokens.push(new crearToken(yytext, "palabra reservada print", yylloc.first_line, yylloc.first_column)); return 'RPRINT';}
"main"				{ listaTokens.push(new crearToken(yytext, "palabra reservada main", yylloc.first_line, yylloc.first_column)); return 'RMAIN';}

","					{ listaTokens.push(new crearToken(yytext, "coma", yylloc.first_line, yylloc.first_column)); return 'COMA';}
"."					{ listaTokens.push(new crearToken(yytext, "punto", yylloc.first_line, yylloc.first_column)); return 'PUNTO';}
";"					{ listaTokens.push(new crearToken(yytext, "punto y coma", yylloc.first_line, yylloc.first_column)); return 'PTCOMA';}
"{"					{ listaTokens.push(new crearToken(yytext, "llave izquierda", yylloc.first_line, yylloc.first_column)); return 'LLAVIZQ';}
"}"					{ listaTokens.push(new crearToken(yytext, "llave derecha", yylloc.first_line, yylloc.first_column)); return 'LLAVDER';}
"("					{ listaTokens.push(new crearToken(yytext, "parentesis izquierdo", yylloc.first_line, yylloc.first_column)); return 'PARIZQ';}
")"					{ listaTokens.push(new crearToken(yytext, "parentesis derecho", yylloc.first_line, yylloc.first_column)); return 'PARDER';}
"["					{ listaTokens.push(new crearToken(yytext, "corchete izquiedo", yylloc.first_line, yylloc.first_column)); return 'CORIZQ';}
"]"					{ listaTokens.push(new crearToken(yytext, "corchete derecho", yylloc.first_line, yylloc.first_column)); return 'CORDER';} 


"&&"				{ listaTokens.push(new crearToken(yytext, "and", yylloc.first_line, yylloc.first_column)); return 'AND';}
"||"				{ listaTokens.push(new crearToken(yytext, "or", yylloc.first_line, yylloc.first_column)); return 'OR';}
"++"				{ listaTokens.push(new crearToken(yytext, "incremento", yylloc.first_line, yylloc.first_column)); return 'MASMAS';}
"--"				{ listaTokens.push(new crearToken(yytext, "decremento", yylloc.first_line, yylloc.first_column)); return 'MENOSMENOS';}

"+"					{ listaTokens.push(new crearToken(yytext, "mas", yylloc.first_line, yylloc.first_column)); return 'MAS';}
"-"					{ listaTokens.push(new crearToken(yytext, "menos", yylloc.first_line, yylloc.first_column)); return 'MENOS';}
"*"					{ listaTokens.push(new crearToken(yytext, "por", yylloc.first_line, yylloc.first_column)); return 'POR';}
"/"					{ listaTokens.push(new crearToken(yytext, "dividido", yylloc.first_line, yylloc.first_column)); return 'DIVIDIDO';}



"<="				{ listaTokens.push(new crearToken(yytext, "menor igual", yylloc.first_line, yylloc.first_column)); return 'MENIGQUE';}
">="				{ listaTokens.push(new crearToken(yytext, "mayor igual", yylloc.first_line, yylloc.first_column)); return 'MAYIGQUE';}
"=="				{ listaTokens.push(new crearToken(yytext, "comparacion", yylloc.first_line, yylloc.first_column)); return 'DOBLEIG';}
"!="				{ listaTokens.push(new crearToken(yytext, "distinto", yylloc.first_line, yylloc.first_column)); return 'NOIG';}

"<"					{ listaTokens.push(new crearToken(yytext, "menor", yylloc.first_line, yylloc.first_column)); return 'MENQUE';}
">"					{ listaTokens.push(new crearToken(yytext, "mayor", yylloc.first_line, yylloc.first_column)); return 'MAYQUE';}
"="					{ listaTokens.push(new crearToken(yytext, "igual", yylloc.first_line, yylloc.first_column)); return 'IGUAL';}

"!"					{ listaTokens.push(new crearToken(yytext, "negacion", yylloc.first_line, yylloc.first_column)); return 'NOT';}
"^"					{ listaTokens.push(new crearToken(yytext, "xor", yylloc.first_line, yylloc.first_column)); return 'XOR';}

\"[^\"]*\"				{ yytext = yytext.substr(1,yyleng-2); listaTokens.push(new crearToken(yytext, "cadena", yylloc.first_line, yylloc.first_column)); return 'CADENA'; }
\'[^\']\'				{ yytext = yytext.substr(1,yyleng-2); listaTokens.push(new crearToken(yytext, "caracter", yylloc.first_line, yylloc.first_column)); return 'CARACTER'; }
[0-9]+("."[0-9]+)?\b  	{ listaTokens.push(new crearToken(yytext, "decimal", yylloc.first_line, yylloc.first_column)); return 'DECIMAL';}
[0-9]+\b				{ listaTokens.push(new crearToken(yytext, "entero", yylloc.first_line, yylloc.first_column)); return 'ENTERO';}
([a-zA-Z])[a-zA-Z0-9_]*	{ listaTokens.push(new crearToken(yytext, "identificador", yylloc.first_line, yylloc.first_column)); return 'IDENTIFICADOR';}


<<EOF>>				return 'EOF';
.					{ console.error('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column);
						errores_lexicos.push(new crearErrorL("El caracter "+ yytext + " no pertenece al lenguaje.", yylloc.first_line, yylloc.first_column));
					}

/lex





/* Asociación de operadores y precedencia */
%left 'MAS' 'MENOS'
%left 'POR' 'DIVIDIDO'
%left UMENOS
%left UNEGADO

%start ini

%% /* Definición de la gramática */


ini
	: lista_clases  EOF 
    { 
        var raiz = new ast("ini",new Array($1)); 
        //console.log(JSON.stringify(raiz));
        var nuevaListaTokens = listaTokens;
        var nuevaListaErroresL = errores_lexicos;
        var nuevaListaErroresS = errores_sintacticos;
        listaTokens = [];
        errores_lexicos = [];
        errores_sintacticos = [];
        return new crearRespuesta(nuevaListaTokens, nuevaListaErroresL, nuevaListaErroresS, raiz);
    }
;

lista_clases
    : lista_clases clase_interfaz { let arreglo5 = []; arreglo5.push($1); arreglo5.push($2)   ; $$ = new ast("lista_clases",arreglo5);  ;}
    | clase_interfaz { $$ = new ast("lista_clases",new Array($1)); }
    
;

clase_interfaz
    : RPUBLIC tipo_clase IDENTIFICADOR bloqueclase_interfaz  { let arreglo4 = []; arreglo4.push($1); arreglo4.push($2); arreglo4.push($3); arreglo4.push($4); $$ = new ast("clase",arreglo4);  }
    | error PTCOMA { console.error('Este es un error clase_interfaz sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column); 
                        errores_sintacticos.push(new crearErrorS("Error sintactico "+ yytext + " en clase_interfaz ", this._$.first_line, this._$.first_column));
                    }
;

bloqueclase_interfaz
    : LLAVIZQ  LLAVDER { let arreglobloqueclase_interfaz1 = []; arreglobloqueclase_interfaz1.push($1); arreglobloqueclase_interfaz1.push($2); $$ = new ast("bloqueclase_interfaz",arreglobloqueclase_interfaz1); }
    | LLAVIZQ lista_instrucciones_clase LLAVDER { let arreglobloqueclase_interfaz2 = []; arreglobloqueclase_interfaz2.push($1); arreglobloqueclase_interfaz2.push($2); arreglobloqueclase_interfaz2.push($3); $$ = new ast("bloqueclase_interfaz",arreglobloqueclase_interfaz2); }
;

tipo_clase 
    : RCLASS  { $$ = new ast("tipo_clase",new Array($1));  }
    | RINTERFACE { $$ = new ast("tipo_clase",new Array($1));  }
;


lista_instrucciones_clase
    : lista_instrucciones_clase instrucciones_clase { let arreglolista_instruccionesclase = []; arreglolista_instruccionesclase.push($1); arreglolista_instruccionesclase.push($2); $$ = new ast("lista_instrucciones_clase", arreglolista_instruccionesclase); }
    | instrucciones_clase { $$ = new ast("lista_instrucciones_clase",new Array($1));  }
;

instrucciones_clase
    : declaracion PTCOMA { let arregloinstrucciones_clase = []; arregloinstrucciones_clase.push($1); arregloinstrucciones_clase.push($2); $$ = new ast("instrucciones_clase", arregloinstrucciones_clase); }
    | metodo_funcion { $$ = new ast("instrucciones_clase",new Array($1));  }
    | error PTCOMA { console.error('Este es un error instrucciones_clase sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column); 
                        errores_sintacticos.push(new crearErrorS("Error sintactico "+ yytext + " en instrucciones_clase ", this._$.first_line, this._$.first_column));
                    }
;

metodo_funcion
    : RPUBLIC tipo_funcion IDENTIFICADOR bloqueparametros  bloquemetodo_funcion { let arreglometodo_funcion= []; arreglometodo_funcion.push($1); arreglometodo_funcion.push($2); arreglometodo_funcion.push($3); arreglometodo_funcion.push($4); arreglometodo_funcion.push($5); $$ = new ast("metodo_funcion", arreglometodo_funcion); }
    | RPUBLIC RSTATIC RVOID RMAIN PARIZQ RSTRING CORIZQ  CORDER IDENTIFICADOR PARDER bloquemetodo_funcion { let arreglometodo_funcion2= []; arreglometodo_funcion2.push($1); arreglometodo_funcion2.push($2); arreglometodo_funcion2.push($3); arreglometodo_funcion2.push($4); arreglometodo_funcion2.push($5); arreglometodo_funcion2.push($6); arreglometodo_funcion2.push($7); arreglometodo_funcion2.push($8); arreglometodo_funcion2.push($9); arreglometodo_funcion2.push($10); arreglometodo_funcion2.push($11); $$ = new ast("metodo_funcion", arreglometodo_funcion2); }
; 

bloqueparametros
    : PARIZQ  PARDER { let arreglobloqueparametros1 = []; arreglobloqueparametros1.push($1); arreglobloqueparametros1.push($2); $$ = new ast("bloqueparametros", arreglobloqueparametros1); }
    | PARIZQ lista_parametros PARDER { let arreglobloqueparametros2 = []; arreglobloqueparametros2.push($1); arreglobloqueparametros2.push($2); arreglobloqueparametros2.push($3); $$ = new ast("bloqueparametros", arreglobloqueparametros2); }
;


bloquemetodo_funcion
    : LLAVIZQ  LLAVDER { let arreglobloquemetodo_funcion1 = []; arreglobloquemetodo_funcion1.push($1); arreglobloquemetodo_funcion1.push($2); $$ = new ast("bloquemetodo_funcion",arreglobloquemetodo_funcion1); }
    | LLAVIZQ lista_instrucciones LLAVDER { let arreglobloquemetodo_funcion2 = []; arreglobloquemetodo_funcion2.push($1); arreglobloquemetodo_funcion2.push($2); arreglobloquemetodo_funcion2.push($3); $$ = new ast("bloquemetodo_funcion",arreglobloquemetodo_funcion2); }
;

lista_instrucciones
    : lista_instrucciones instrucciones { let arreglolista_instrucciones = []; arreglolista_instrucciones.push($1); arreglolista_instrucciones.push($2); $$ = new ast("lista_instrucciones", arreglolista_instrucciones); }
    | instrucciones                     { $$ = new ast("lista_instrucciones",new Array($1)); }
;

instrucciones
    : asignacion_for PTCOMA { let arregloinstrucciones1 = []; arregloinstrucciones1.push($1); arregloinstrucciones1.push($2); $$ = new ast("instrucciones", arregloinstrucciones1); }
    | imprimir PTCOMA { let arregloinstrucciones2 = []; arregloinstrucciones2.push($1); arregloinstrucciones2.push($2); $$ = new ast("instrucciones", arregloinstrucciones2); }
    | sentencia_if { $$ = new ast("instrucciones",new Array($1)); }
    | sentencia_for { $$ = new ast("instrucciones",new Array($1)); }
    | sentencia_while { $$ = new ast("instrucciones",new Array($1)); }
    | sentencia_do { $$ = new ast("instrucciones",new Array($1)); }
    | sentencia_return { $$ = new ast("instrucciones",new Array($1)); }
    | sentencia_continuebreak PTCOMA { let arregloinstrucciones3 = []; arregloinstrucciones3.push($1); arregloinstrucciones3.push($2); $$ = new ast("instrucciones", arregloinstrucciones3); }
;

sentencia_continuebreak
    : RCONTINUE { $$ = new ast("sentencia_continuebreak",new Array($1)); }
    | RBREAK    { $$ = new ast("sentencia_continuebreak",new Array($1)); }
;

sentencia_return
    : RRETURN expresion PTCOMA { let arreglosentencia_return = []; arreglosentencia_return.push($1); arreglosentencia_return.push($2); arreglosentencia_return.push($3); $$ = new ast("sentencia_return", arreglosentencia_return); }
;

sentencia_do
    : RDO bloque RWHILE PARIZQ expresion PARDER PTCOMA  { let arreglosentencia_do = []; arreglosentencia_do.push($1); arreglosentencia_do.push($2); arreglosentencia_do.push($3); arreglosentencia_do.push($4); arreglosentencia_do.push($5); arreglosentencia_do.push($6); arreglosentencia_do.push($7); $$ = new ast("sentencia_do", arreglosentencia_do); }
;

sentencia_while
    : RWHILE PARIZQ expresion PARDER bloque { let arreglosentencia_while = []; arreglosentencia_while.push($1); arreglosentencia_while.push($2); arreglosentencia_while.push($3); arreglosentencia_while.push($4); arreglosentencia_while.push($5); $$ = new ast("sentencia_while", arreglosentencia_while); }
;

sentencia_for
    : RFOR PARIZQ asignacion_for PTCOMA expresion_logica PTCOMA asignacion  PARDER bloque { let arreglosentencia_for = []; arreglosentencia_for.push($1); arreglosentencia_for.push($2); arreglosentencia_for.push($3); arreglosentencia_for.push($4); arreglosentencia_for.push($5); arreglosentencia_for.push($6); arreglosentencia_for.push($7); arreglosentencia_for.push($8); arreglosentencia_for.push($9); $$ = new ast("sentencia_for", arreglosentencia_for); }
;

sentencia_if
    : lista_condicionesIf RELSE  bloque { let arreglosentencia_if1 = []; arreglosentencia_if1.push($1); arreglosentencia_if1.push($2); arreglosentencia_if1.push($3); $$ = new ast("sentencia_if", arreglosentencia_if1);}
    | lista_condicionesIf    { $$ = new ast("sentencia_if",new Array($1)); }
;

lista_condicionesIf
    : lista_condicionesIf RELSE RIF PARIZQ expresion PARDER bloque { let arreglolista_condicionesIf1 = []; arreglolista_condicionesIf1.push($1); arreglolista_condicionesIf1.push($2); arreglolista_condicionesIf1.push($3); arreglolista_condicionesIf1.push($4); arreglolista_condicionesIf1.push($5); arreglolista_condicionesIf1.push($6); arreglolista_condicionesIf1.push($7); $$ = new ast("lista_condicionesIf", arreglolista_condicionesIf1);}
    | RIF PARIZQ expresion PARDER bloque { let arreglolista_condicionesIf2 = []; arreglolista_condicionesIf2.push($1); arreglolista_condicionesIf2.push($2); arreglolista_condicionesIf2.push($3); arreglolista_condicionesIf2.push($4); arreglolista_condicionesIf2.push($5); $$ = new ast("lista_condicionesIf", arreglolista_condicionesIf2);}
;

bloque
    : LLAVIZQ LLAVDER { let arreglobloque1 = []; arreglobloque1.push($1); arreglobloque1.push($2);  $$ = new ast("bloque", arreglobloque1);}
    | LLAVIZQ lista_instrucciones LLAVDER { let arreglobloque2 = []; arreglobloque2.push($1); arreglobloque2.push($2); arreglobloque2.push($3); $$ = new ast("bloque", arreglobloque2);}
;

imprimir
    : RSYSTEM PUNTO ROUT PUNTO tipo_imprimir PARIZQ expresion PARDER { let arregloimprimir = []; arregloimprimir.push($1); arregloimprimir.push($2); arregloimprimir.push($3); arregloimprimir.push($4); arregloimprimir.push($5); arregloimprimir.push($6); arregloimprimir.push($7); arregloimprimir.push($8); $$ = new ast("imprimir", arregloimprimir); }
;

tipo_imprimir
    : RPRINTLN { $$ = new ast("tipo_imprimir",new Array($1)); }
    | RPRINT { $$ = new ast("tipo_imprimir",new Array($1)); }
;

asignacion_for
    : asignacion    { $$ = new ast("asignacion_for",new Array($1)); }
    | declaracion   { $$ = new ast("asignacion_for",new Array($1)); }
;

asignacion
    : IDENTIFICADOR IGUAL expresion    { let arregloasignacion1 = []; arregloasignacion1.push($1); arregloasignacion1.push($2); arregloasignacion1.push($3); $$ = new ast("asignacion", arregloasignacion1);  }
    | IDENTIFICADOR MASMAS                      { let arregloasignacion2 = []; arregloasignacion2.push($1); arregloasignacion2.push($2); $$ = new ast("asignacion", arregloasignacion2);  }
    | IDENTIFICADOR MENOSMENOS                  { let arregloasignacion3 = []; arregloasignacion3.push($1); arregloasignacion3.push($2); $$ = new ast("asignacion", arregloasignacion3);  }
;

lista_parametros
    : lista_parametros COMA parametro   { let arreglolista_parametros = []; arreglolista_parametros.push($1); arreglolista_parametros.push($2); arreglolista_parametros.push($3);  $$ = new ast("lista_parametros", arreglolista_parametros); }
    | parametro                         { $$ = new ast("lista_parametros",new Array($1)); }
;

parametro
    : tipo_variable IDENTIFICADOR { let arregloparametro = []; arregloparametro.push($1); arregloparametro.push($2); $$ = new ast("parametro", arregloparametro); }
;


tipo_funcion
    : RVOID             { $$ = new ast("tipo_funcion",new Array($1)); }
    | tipo_variable     { $$ = new ast("tipo_funcion",new Array($1)); }
;

declaracion
    : tipo_variable lista_declaraciones { let arreglodeclaracion = []; arreglodeclaracion.push($1); arreglodeclaracion.push($2); $$ = new ast("declaracion", arreglodeclaracion); }
    
;

tipo_variable
    : RINT      { $$ = new ast("tipo_variable",new Array($1)); }
    | RBOOLEAN  { $$ = new ast("tipo_variable",new Array($1)); }
    | RDOUBLE   { $$ = new ast("tipo_variable",new Array($1)); }
    | RSTRING   { $$ = new ast("tipo_variable",new Array($1)); }
    | RCHAR     { $$ = new ast("tipo_variable",new Array($1)); }
;

lista_declaraciones
    : lista_declaraciones COMA declaraciones { let arreglolista_declaraciones = []; arreglolista_declaraciones.push($1); arreglolista_declaraciones.push($2); arreglolista_declaraciones.push($3); $$ = new ast("lista_declaraciones", arreglolista_declaraciones); }
    | declaraciones { $$ = new ast("lista_declaraciones",new Array($1)); }
;

declaraciones
    : IDENTIFICADOR IGUAL expresion    { let arreglodeclaraciones = []; arreglodeclaraciones.push($1); arreglodeclaraciones.push($2); arreglodeclaraciones.push($3); $$ = new ast("declaraciones", arreglodeclaraciones); }
    | IDENTIFICADOR                    { $$ = new ast("declaraciones",new Array($1)); }
    | error PTCOMA { console.error('Este es un error declaraciones sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column); 
                    errores_sintacticos.push(new crearErrorS("Error sintactico "+ yytext + " en declaraciones ", this._$.first_line, this._$.first_column));
    }

;

expresion
    : expresion_numerica    { $$ = new ast("expresion",new Array($1)); }
    | expresion_logica      { $$ = new ast("expresion",new Array($1)); }
    | error PTCOMA { console.error('Este es un error expresion sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column); 
                        errores_sintacticos.push(new crearErrorS("Error sintactico "+ yytext + " en expresion ", this._$.first_line, this._$.first_column));
    }
;

expresion_numerica
	: MENOS expresion_numerica %prec UMENOS				{ let arregloexpresion_numerica1 = []; arregloexpresion_numerica1.push($1); arregloexpresion_numerica1.push($2); $$ = new ast("expresion_numerica", arregloexpresion_numerica1);  }
	| PARIZQ expresion_numerica PARDER					{ let arregloexpresion_numerica2 = []; arregloexpresion_numerica2.push($1); arregloexpresion_numerica2.push($2); arregloexpresion_numerica2.push($3); $$ = new ast("expresion_numerica", arregloexpresion_numerica2);  }
	| ENTERO											{ $$ = new ast("expresion_numerica",new Array($1)); }
	| DECIMAL											{ $$ = new ast("expresion_numerica",new Array($1)); }
	| expresion_numerica MAS expresion_numerica			{ let arregloexpresion_numerica3 = []; arregloexpresion_numerica3.push($1); arregloexpresion_numerica3.push($2); arregloexpresion_numerica3.push($3); $$ = new ast("expresion_numerica", arregloexpresion_numerica3);}
	| expresion_numerica MENOS expresion_numerica		{ let arregloexpresion_numerica4 = []; arregloexpresion_numerica4.push($1); arregloexpresion_numerica4.push($2); arregloexpresion_numerica4.push($3); $$ = new ast("expresion_numerica", arregloexpresion_numerica4);}
	| expresion_numerica POR expresion_numerica			{ let arregloexpresion_numerica5 = []; arregloexpresion_numerica5.push($1); arregloexpresion_numerica5.push($2); arregloexpresion_numerica5.push($3); $$ = new ast("expresion_numerica", arregloexpresion_numerica5);}
	| expresion_numerica DIVIDIDO expresion_numerica	{ let arregloexpresion_numerica6 = []; arregloexpresion_numerica6.push($1); arregloexpresion_numerica6.push($2); arregloexpresion_numerica6.push($3); $$ = new ast("expresion_numerica", arregloexpresion_numerica6);}
    | IDENTIFICADOR MASMAS	                            { console.log("que onda");let arregloexpresion_numerica13 = []; arregloexpresion_numerica13.push($1); arregloexpresion_numerica13.push($2);  $$ = new ast("expresion_numerica", arregloexpresion_numerica13);}
    | IDENTIFICADOR MENOSMENOS	                        { let arregloexpresion_numerica14 = []; arregloexpresion_numerica14.push($1); arregloexpresion_numerica14.push($2);  $$ = new ast("expresion_numerica", arregloexpresion_numerica14);}
	| IDENTIFICADOR										{  $$ = new ast("expresion_numerica",new Array($1)); }
    | CADENA										    { $$ = new ast("expresion_numerica",new Array($1)); }
    | CARACTER										    { $$ = new ast("expresion_numerica",new Array($1)); }
;


expresion_relacional
	: expresion_numerica MENQUE expresion_numerica	    { let arregloexpresion_numerica8 = []; arregloexpresion_numerica8.push($1); arregloexpresion_numerica8.push($2); arregloexpresion_numerica8.push($3); $$ = new ast("expresion_relacional", arregloexpresion_numerica8);}
    | expresion_numerica MAYQUE expresion_numerica	    { let arregloexpresion_numerica9 = []; arregloexpresion_numerica9.push($1); arregloexpresion_numerica9.push($2); arregloexpresion_numerica9.push($3); $$ = new ast("expresion_relacional", arregloexpresion_numerica9);}
	| expresion_numerica MENIGQUE expresion_numerica	{ let arregloexpresion_numerica10 = []; arregloexpresion_numerica10.push($1); arregloexpresion_numerica10.push($2); arregloexpresion_numerica10.push($3); $$ = new ast("expresion_relacional", arregloexpresion_numerica10);}
    | expresion_numerica MAYIGQUE expresion_numerica	{ let arregloexpresion_numerica11 = []; arregloexpresion_numerica11.push($1); arregloexpresion_numerica11.push($2); arregloexpresion_numerica11.push($3); $$ = new ast("expresion_relacional", arregloexpresion_numerica11);}
    | expresion_numerica DOBLEIG expresion_numerica	    { let arregloexpresion_numerica7 = []; arregloexpresion_numerica7.push($1); arregloexpresion_numerica7.push($2); arregloexpresion_numerica7.push($3); $$ = new ast("expresion_relacional", arregloexpresion_numerica7);}
    | expresion_numerica NOIG expresion_numerica	    { let arregloexpresion_numerica12 = []; arregloexpresion_numerica12.push($1); arregloexpresion_numerica12.push($2); arregloexpresion_numerica12.push($3); $$ = new ast("expresion_relacional", arregloexpresion_numerica12);}
    | RTRUE										        { $$ = new ast("expresion_relacional",new Array($1)); }
    | RFALSE										    { $$ = new ast("expresion_relacional",new Array($1)); }
;


expresion_logica
	: NOT expresion_logica	 %prec UNEGADO			{ let arregloexpresion_logica4 = []; arregloexpresion_logica4.push($1); arregloexpresion_logica4.push($2); $$ = new ast("expresion_logica", arregloexpresion_logica4);}
    | PARIZQ expresion_logica PARDER				{ let arregloexpresion_logica5 = []; arregloexpresion_logica5.push($1); arregloexpresion_logica5.push($2); arregloexpresion_logica5.push($3); $$ = new ast("expresion_logica", arregloexpresion_logica5);}
	| expresion_relacional AND expresion_logica     { let arregloexpresion_logica1 = []; arregloexpresion_logica1.push($1); arregloexpresion_logica1.push($2); arregloexpresion_logica1.push($3); $$ = new ast("expresion_logica", arregloexpresion_logica1);}
	| expresion_relacional OR expresion_logica 		{ let arregloexpresion_logica2 = []; arregloexpresion_logica2.push($1); arregloexpresion_logica2.push($2); arregloexpresion_logica2.push($3); $$ = new ast("expresion_logica", arregloexpresion_logica2);}
    | expresion_relacional XOR expresion_logica 	{ let arregloexpresion_logica3 = []; arregloexpresion_logica3.push($1); arregloexpresion_logica3.push($2); arregloexpresion_logica3.push($3); $$ = new ast("expresion_logica", arregloexpresion_logica3);}
	| expresion_relacional								{ $$ = new ast("expresion_logica",new Array($1)); }
    
;
